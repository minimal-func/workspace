import EditorJS from '@editorjs/editorjs';
import Header from '@editorjs/header';
import List from '@editorjs/list';
import Image from '@editorjs/image';
import Quote from '@editorjs/quote';
import Code from '@editorjs/code';
import InlineCode from '@editorjs/inline-code';
import Table from '@editorjs/table';
import LinkTool from '@editorjs/link';
import Marker from '@editorjs/marker';
import Warning from '@editorjs/warning';
import Checklist from '@editorjs/checklist';
import Delimiter from '@editorjs/delimiter';
import Raw from '@editorjs/raw';
import Embed from '@editorjs/embed';

export default class PostEditor {
  constructor(containerId, initialData, options = {}) {
    this.containerId = containerId;
    this.initialData = initialData;
    this.onChange = options.onChange || (() => {});
    this.projectId = options.projectId;
    this.postId = options.postId;
    this.editor = null;
    this.init();
  }

  init() {
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');
    
    const tools = {
      header: {
        class: Header,
        inlineToolbar: true
      },
      paragraph: {
        inlineToolbar: true
      },
      list: {
        class: List,
        inlineToolbar: true,
        config: {
          defaultStyle: 'unordered'
        }
      },
      checklist: {
        class: Checklist,
        inlineToolbar: true
      },
      quote: {
        class: Quote,
        inlineToolbar: true,
        config: {
          quotePlaceholder: 'Enter a quote',
          captionPlaceholder: 'Quote\'s author',
        },
      },
      warning: {
        class: Warning,
        inlineToolbar: true
      },
      marker: Marker,
      code: Code,
      inlineCode: InlineCode,
      delimiter: Delimiter,
      linkTool: {
        class: LinkTool,
        config: {
          endpoint: this.projectId ? `/projects/${this.projectId}/link_metadata/fetch` : '/notifications/link_metadata/fetch',
        }
      },
      table: {
        class: Table,
        inlineToolbar: true
      },
      raw: Raw,
      embed: Embed,
      image: {
        class: Image,
        config: {
          endpoints: {
            byFile: this.projectId ? `/projects/${this.projectId}/posts/${this.postId || 'new'}/images` : '/notifications/images', // Placeholder for non-project uploads
            byUrl: this.projectId ? `/projects/${this.projectId}/posts/${this.postId || 'new'}/images/fetch_url` : '/notifications/images/fetch_url',
          },
          additionalRequestHeaders: csrfToken ? {
            'X-CSRF-Token': csrfToken
          } : {}
        }
      }
    };
    
    this.editor = new EditorJS({
      holder: this.containerId,
      data: this.initialData,
      placeholder: 'Let`s write an awesome story!',
      tools: tools,
      onChange: async () => {
        try {
          const data = await this.editor.save();
          this.onChange(data);
        } catch (error) {
          console.error('EditorJS save failed', error);
        }
      }
    });
  }

  async save() {
    return await this.editor.save();
  }
}
