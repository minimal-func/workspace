// Import the Datepicker class from the vanillajs-datepicker package
import { Datepicker } from 'vanillajs-datepicker';

// Import the datepicker CSS
import 'vanillajs-datepicker/css/datepicker.css';

// Function to initialize datepickers
function initDatepickers() {
  document.querySelectorAll('.input-datepicker').forEach(element => {
    // Check if the element already has a datepicker instance
    if (!element._datepicker) {
      // Create a new datepicker instance
      const datepicker = new Datepicker(element, {
        // Add any options you need here
        autohide: true,
        format: 'yyyy-mm-dd',
      });

      // Store the datepicker instance on the element for easy access
      element._datepicker = datepicker;

      // Ensure click event is properly attached for input elements
      if (element.tagName.toLowerCase() === 'input') {
        // Remove any existing click listeners to avoid duplicates
        element.removeEventListener('click', showDatepicker);
        // Add click listener
        element.addEventListener('click', showDatepicker);
      }
    }
  });
}

// Function to show datepicker when input is clicked
function showDatepicker(event) {
  const input = event.target;
  if (input._datepicker) {
    input._datepicker.show();
  }
}

// Export the Datepicker class and initialization function
export { Datepicker, initDatepickers };
