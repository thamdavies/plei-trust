export function findElement(root, selector) {
  if (typeof root === 'string') {
    return document.querySelector(root);
  }
  return root.querySelector(selector);
}

export function getMetaValue(name) {
  const element = findElement(document.head, `meta[name="${name}"]`);
  if (element) {
    return element.getAttribute('content');
  }

  return undefined;
}

export function toArray(value) {
  if (Array.isArray(value)) {
    return value;
  }
  if (Array.from) {
    return Array.from(value);
  }
  return [].slice.call(value);
}

export function removeElement(el) {
  if (el && el.parentNode) {
    el.parentNode.removeChild(el);
  }
}

export function insertAfter(el, referenceNode) {
  return referenceNode.parentNode.insertBefore(el, referenceNode.nextSibling);
}

export function formatCurrency(number, currency = 'VND') {
  let amount = number.toLocaleString('it-IT', { style: 'currency', currency: 'VND' });
  if (!currency) amount = amount.replace('VND', '').trim();

  return amount;
}
