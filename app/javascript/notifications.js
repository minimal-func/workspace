export const initNotifications = () => {
  const notifications = document.querySelectorAll('.notification[data-animation]');
  
  notifications.forEach(notification => {
    // Reveal the notification
    setTimeout(() => {
      notification.classList.add('notification--reveal');
    }, 100);

    // Auto-dismiss after 5 seconds
    const timeout = setTimeout(() => {
      dismissNotification(notification);
    }, 5000);

    // Handle close button
    const closeButton = notification.querySelector('.notification-close-cross');
    if (closeButton) {
      closeButton.addEventListener('click', () => {
        clearTimeout(timeout);
        dismissNotification(notification);
      });
    }
  });

  function dismissNotification(notification) {
    notification.classList.add('notification--dismissed');
    notification.addEventListener('animationend', () => {
      notification.remove();
    }, { once: true });
    
    // Fallback if animation fails
    setTimeout(() => {
      if (notification.parentNode) {
        notification.remove();
      }
    }, 500);
  }
};
