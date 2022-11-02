import '../stylesheets/application';

var componentRequireContext = require.context("components", true);
var ReactRailsUJS = require("react_ujs");
ReactRailsUJS.useContext(componentRequireContext);

import Trix from "trix";
require("@rails/actiontext")

$.ajaxSetup({
  headers: {
    "X-CSRF-Token": $('meta[name="csrf-token"]').attr("content"),
  },
});

$(function() {

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
          $.ajax({
            method: "POST",
            url: document.querySelector("[data-embeds-path]").dataset
              .embedsPath,
            data: {
              embed: {
                content,
              },
            },
            success: ({content, sgid}) => {
              const attachment = new Trix.Attachment({
                content,
                sgid,
              });
              editor.insertAttachment(attachment);
              editor.insertLineBreak();
            },
          });
        }
      });
  }
});

$(function() {
  $(".embed").each(function(i, embed) {
    const $embed = $(embed);
    $embed
      .find(".content")
      .replaceWith($embed.find(".embed-html").text());
  });
});

require("trix")