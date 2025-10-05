
/**
 * Decodes a base64 string into a binary buffer.
 */
export function base64ToBuffer(base64) {
  const binaryString = atob(base64);
  const bytes = new Uint8Array(binaryString.length);
  const length = bytes.byteLength;

  for (let i = 0; i < length; i++) {
    bytes[i] = binaryString.charCodeAt(i);
  }

  return bytes.buffer;
}

export function cookieOptions() {
  if (document.body.hasAttribute("data-within-iframe")) {
    return ";SameSite=None;Secure";
  } else {
    return ";SameSite=Lax";
  }
}

/**
 * Transforms a UTF8 string into base64 encoding.
 */
export function encodeBase64(string) {
  return btoa(unescape(encodeURIComponent(string)));
}

/**
 * Transforms base64 encoding into UTF8 string.
 */
export function decodeBase64(binary) {
  return decodeURIComponent(escape(atob(binary)));
}
