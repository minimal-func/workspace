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

document.addEventListener('DOMContentLoaded', function() {
  var element = document.querySelector("trix-editor")

  if(element) {
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
    buttonGroup.insertAdjacentHTML("beforeend", buttonHTML);
    dialogGroup.insertAdjacentHTML("beforeend", dialogHml);
    document
      .querySelector('[data-trix-action="embed"]')
      .addEventListener("click", event => {
        const dialog = document.querySelector('[data-trix-dialog="embed"]');
        const embedInput = document.querySelector('[name="embed"]');
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
    document
      .querySelector('[data-trix-custom="add-embed"]')
      .addEventListener("click", event => {
        const content = document.querySelector('[name="embed"]').value;
        if (content) {
          fetch(document.querySelector("[data-embeds-path]").dataset.embedsPath, {
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
});

document.addEventListener('DOMContentLoaded', function() {
  const recordButton = document.getElementById('recordButton');
  const chatForm = document.getElementById('chatForm');
  const textInput = document.getElementById('textInput');
  const conversation = document.getElementById('conversation');

  let recognition;
  if ('webkitSpeechRecognition' in window) {
    recognition = new webkitSpeechRecognition();
  } else {
    recognition = new SpeechRecognition();
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
    textInput.value = speechResult;
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
});

require("trix")

require('./scripts')
