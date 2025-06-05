import React from 'react';
import ReactDOM from 'react-dom';
import TaskBox from '../components/TaskBox';
import "chartkick";
import "chartkick/highcharts";

import Trix from "trix";
require("@rails/actiontext")

import { Turbo } from "@hotwired/turbo-rails";
window.Turbo = Turbo;

document.addEventListener('DOMContentLoaded', loadReact)
document.addEventListener('turbo:render', loadReact)

// Function to get CSRF token from meta tag
function getCSRFToken() {
  return document.querySelector('meta[name="csrf-token"]').getAttribute("content");
}

// Add CSRF token to all fetch requests
const originalFetch = window.fetch;
window.fetch = function(url, options = {}) {
  if (!options.headers) {
    options.headers = {};
  }
  if (options.method && options.method !== 'GET') {
    options.headers["X-CSRF-Token"] = getCSRFToken();
  }
  return originalFetch.call(this, url, options);
};

function loadReact(){
  const rootElement = document.getElementById('root');
  if (rootElement) {
    const presenter = JSON.parse(rootElement.dataset.presenter);
    console.log(presenter);
    ReactDOM.render(<TaskBox presenter={presenter} />, rootElement);
  }
}

// Function to initialize Trix editor with custom embed functionality
function initTrixEditor() {
  var element = document.querySelector("trix-editor")

  if(element && element.toolbarElement) {
    var editor = element.editor;

    const buttonHTML =
      '<button type="button" class="trix-button" data-trix-attribute="embed" data-trix-action="embed" title="Embed" tabindex="-1">Media</button>';
    const buttonGroup = element.toolbarElement.querySelector(
      ".trix-button-group--block-tools"
    );
    const dialogHml = `<div class="trix-dialog trix-dialog--link" data-trix-dialog="embed" data-trix-dialog-attribute="embed">
      <div class="trix-dialog__link-fields">
        <input type="text" name="embed" class="trix-input trix-input--dialog" placeholder="Paste your video or sound url" aria-label="embed code" required="" data-trix-input="" disabled="disabled">
        <div class="trix-button-group">
          <input type="button" class="trix-button trix-button--dialog" data-trix-custom="add-embed" value="Add">
        </div>
      </div>
    </div>`;
    const dialogGroup = element.toolbarElement.querySelector(
      ".trix-dialogs"
    );
    if (buttonGroup && dialogGroup) {
      buttonGroup.insertAdjacentHTML("beforeend", buttonHTML);
      dialogGroup.insertAdjacentHTML("beforeend", dialogHml);
    } else {
      return; // Exit if required elements are not found
    }
    const embedButton = document.querySelector('[data-trix-action="embed"]');
    if (embedButton) {
      embedButton.addEventListener("click", event => {
        const dialog = document.querySelector('[data-trix-dialog="embed"]');
        const embedInput = document.querySelector('[name="embed"]');

        if (!dialog || !embedInput) return; // Exit if required elements are not found

        if (event.target.classList.contains("trix-active")) {
          event.target.classList.remove("trix-active");
          dialog.classList.remove("trix-active");
          delete dialog.dataset.trixActive;
          embedInput.setAttribute("disabled", "disabled");
        } else {
          event.target.classList.add("trix-active");
          dialog.classList.add("trix-active");
          dialog.dataset.trixActive = "";
          embedInput.removeAttribute("disabled");
          embedInput.focus();
        }
      });
    }
    const addEmbedButton = document.querySelector('[data-trix-custom="add-embed"]');
    if (addEmbedButton) {
      addEmbedButton.addEventListener("click", event => {
        const embedInput = document.querySelector('[name="embed"]');
        if (!embedInput) return; // Exit if required element is not found

        const content = embedInput.value;
        const embedsPathElement = document.querySelector("[data-embeds-path]");

        if (content && embedsPathElement) {
          fetch(embedsPathElement.dataset.embedsPath, {
            method: "POST",
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({
              embed: {
                content,
              },
            }),
          })
          .then(response => response.json())
          .then(({content, sgid}) => {
            const attachment = new Trix.Attachment({
              content,
              sgid,
            });
            editor.insertAttachment(attachment);
            editor.insertLineBreak();
          })
          .catch(error => console.error('Error:', error));
        }
      });
    }
  }
}

// Initialize Trix editor on DOMContentLoaded
document.addEventListener('DOMContentLoaded', initTrixEditor);

// Also initialize Trix editor on Turbo navigation
document.addEventListener('turbo:render', initTrixEditor);

// Function to initialize speech recognition, chat form, and embed handling
function initChatAndEmbeds() {
  const recordButton = document.getElementById('recordButton');
  const chatForm = document.getElementById('chatForm');
  const textInput = document.getElementById('textInput');
  const conversation = document.getElementById('conversation');

  let recognition;
  if ('webkitSpeechRecognition' in window) {
    recognition = new webkitSpeechRecognition();
  } else if ('SpeechRecognition' in window) {
    recognition = new SpeechRecognition();
  } else {
    console.warn('Speech recognition not supported in this browser');
    return;
  }
  recognition.continuous = false;
  recognition.interimResults = false;
  recognition.lang = 'en-US';

  if (recordButton) {
    recordButton.addEventListener('click', () => {
      recognition.start();
    });
  }

  recognition.onresult = (event) => {
    const speechResult = event.results[0][0].transcript;
    if (textInput) {
      textInput.value = speechResult;
    }
  };

  recognition.onerror = (event) => {
    console.error('Speech recognition error', event);
  };

  if (chatForm) {
    chatForm.addEventListener('submit', async (event) => {
      event.preventDefault();
      const userMessage = textInput.value;
      if (userMessage) {
        addMessageToConversation('User', userMessage);
        await sendMessageToChatGPT(userMessage);
        textInput.value = '';
      }
    });
  }

  function addMessageToConversation(sender, message) {
    const messageDiv = document.createElement('div');
    messageDiv.className = 'message';
    messageDiv.innerHTML = `<span class="${sender.toLowerCase()}">${sender}:</span> ${message}`;
    if (conversation) {
      conversation.appendChild(messageDiv);
      conversation.scrollTop = conversation.scrollHeight;
    }
  }

  async function sendMessageToChatGPT(message) {
    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

    const response = await fetch('/chatgpt', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken
      },
      body: JSON.stringify({ message })
    });

    const data = await response.json();
    const chatGPTMessage = data.message;
    addMessageToConversation('ChatGPT', chatGPTMessage);
  }

  // Replace jQuery embed handling with vanilla JS
  document.querySelectorAll(".embed").forEach(embed => {
    const content = embed.querySelector(".content");
    const embedHtml = embed.querySelector(".embed-html");
    if (content && embedHtml) {
      content.outerHTML = embedHtml.textContent;
    }
  });
}

// Initialize chat and embeds on DOMContentLoaded
document.addEventListener('DOMContentLoaded', initChatAndEmbeds);

// Also initialize chat and embeds on Turbo navigation
document.addEventListener('turbo:render', initChatAndEmbeds);

require("trix")

// Import our custom scripts
import './scripts'
