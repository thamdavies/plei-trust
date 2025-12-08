import { FetchRequest } from '@rails/request.js';

export const alertController = (() => {
  /**
   * Displays an alert message by sending a POST request to the alerts endpoint
   * @param {string} message - The alert message to display
   * @param {string} type - The type/category of the alert (e.g., 'success', 'error')
   * @returns {void}
   */
  const show = (message, type) => {
    const request = new FetchRequest('post', '/alerts', {
      responseKind: 'turbo-stream',
      body: JSON.stringify({ message, type }),
    });

    request.perform();
  };

  return {
    show,
  };
})();
