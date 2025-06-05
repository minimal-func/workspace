// Vanilla JavaScript implementation of dropdown functionality
// This replaces the jQuery-based implementation that was previously used

// Create a namespace for our utility functions
const mr = {};

// Initialize the dropdowns module
mr.dropdowns = {
  // Flag to track initialization
  done: false,

  // Function to run when the document is ready
  documentReady: function() {
    // Only initialize once
    if (!mr.dropdowns.done) {
      // Set up click handlers for dropdown triggers
      document.querySelectorAll('.dropdown__trigger').forEach(trigger => {
        trigger.addEventListener('click', function(e) {
          e.preventDefault();
          const dropdown = this.closest('.dropdown');

          // Toggle active class on the dropdown
          if (dropdown.classList.contains('dropdown--active')) {
            dropdown.classList.remove('dropdown--active');
          } else {
            // Close any other open dropdowns
            document.querySelectorAll('.dropdown--active').forEach(activeDropdown => {
              if (activeDropdown !== dropdown) {
                activeDropdown.classList.remove('dropdown--active');
              }
            });

            dropdown.classList.add('dropdown--active');

            // Position the dropdown
            mr.dropdowns.repositionDropdowns();
          }
        });
      });

      // Close dropdowns when clicking outside
      document.addEventListener('click', function(e) {
        if (!e.target.closest('.dropdown')) {
          document.querySelectorAll('.dropdown--active').forEach(dropdown => {
            dropdown.classList.remove('dropdown--active');
          });
        }
      });

      // Reposition dropdowns on window resize
      window.addEventListener('resize', function() {
        mr.dropdowns.repositionDropdowns();
      });

      // Initial positioning
      mr.dropdowns.repositionDropdowns();

      // Handle RTL layouts if needed
      if (document.querySelector('body[data-direction="rtl"]')) {
        mr.dropdowns.repositionDropdownsRtl();

        window.addEventListener('resize', function() {
          mr.dropdowns.repositionDropdownsRtl();
        });
      }

      mr.dropdowns.done = true;
    }
  },

  // Function to position dropdowns correctly
  repositionDropdowns: function() {
    document.querySelectorAll('.dropdown__container').forEach(container => {
      let containerOffset, masterOffset, menuItem, content;
      const containerMeasure = document.querySelector('.containerMeasure');

      container.style.left = '';

      // Get necessary measurements
      containerOffset = container.getBoundingClientRect().left;
      masterOffset = containerMeasure ? containerMeasure.getBoundingClientRect().left : 0;
      menuItem = container.closest('.dropdown').getBoundingClientRect().left;
      content = null;

      // Position the container
      container.style.left = (menuItem - containerOffset) + 'px';

      // Position dropdown content
      const dropdown = container.querySelector('.dropdown__content');
      if (dropdown) {
        dropdown.style.left = '';

        const offset = dropdown.getBoundingClientRect().left;
        const width = dropdown.offsetWidth;
        const offsetRight = offset + width;
        const winWidth = window.innerWidth;
        const leftCorrect = containerMeasure ? (containerMeasure.offsetWidth || 0) - width : 0;

        if (offsetRight > winWidth) {
          dropdown.style.left = leftCorrect + 'px';
        }
      }
    });
  },

  // Function to position dropdowns correctly in RTL layouts
  repositionDropdownsRtl: function() {
    const windowWidth = window.innerWidth;

    document.querySelectorAll('.dropdown__container').forEach(container => {
      let containerOffset, masterOffset, menuItem, content;
      const containerMeasure = document.querySelector('.containerMeasure');

      container.style.left = '';

      // Get necessary measurements for RTL
      containerOffset = windowWidth - (container.getBoundingClientRect().left + container.offsetWidth);
      masterOffset = containerMeasure ? containerMeasure.getBoundingClientRect().left : 0;
      menuItem = windowWidth - (container.closest('.dropdown').getBoundingClientRect().left + container.closest('.dropdown').offsetWidth);
      content = null;

      // Position the container for RTL
      container.style.right = (menuItem - containerOffset) + 'px';

      // Position dropdown content for RTL
      const dropdown = container.querySelector('.dropdown__content');
      if (dropdown) {
        dropdown.style.right = '';

        const offset = dropdown.getBoundingClientRect().left;
        const width = dropdown.offsetWidth;
        const offsetRight = offset + width;
        const winWidth = window.innerWidth;
        const rightCorrect = containerMeasure ? (containerMeasure.offsetWidth || 0) - width : 0;

        if (offsetRight > winWidth) {
          dropdown.style.right = rightCorrect + 'px';
        }
      }
    });
  }
};

// Set up the components system
mr.components = {
  documentReady: []
};

// Add the dropdowns module to the components to be initialized
mr.components.documentReady.push(mr.dropdowns.documentReady);

// Initialize all components when the DOM is ready or when Turbo renders a new page
document.addEventListener('DOMContentLoaded', function() {
  mr.components.documentReady.forEach(function(component) {
    component();
  });
});

// Also initialize components when Turbo renders a new page
document.addEventListener('turbo:render', function() {
  // Reset the done flag to allow re-initialization
  mr.dropdowns.done = false;
  mr.components.documentReady.forEach(function(component) {
    component();
  });
});

// Export the mr object for use in other files
export default mr;
