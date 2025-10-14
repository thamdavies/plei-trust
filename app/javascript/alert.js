import { FetchRequest } from '@rails/request.js';

export const alertController = (() => {
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
