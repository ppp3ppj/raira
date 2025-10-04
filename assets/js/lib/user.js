import { cookieOptions, decodeBase64, encodeBase64 } from "./utils";

const USER_DATA_COOKIE = "lb_user_data";

/**
 * Stores user data in the `"lb_user_data"` cookie.
 */
export function storeUserData(userData) {
  console.log("store user data");
  const json = JSON.stringify(userData);
  console.log("Store Data: ", json);
  const encoded = encodeBase64(json);
  setCookie(USER_DATA_COOKIE, encoded, 157_680_000); // 5 years
}

/**
 * Loads user data from the `"lb_user_data"` cookie.
 */
export function loadUserData() {
  console.log("Loding user data");
  const encoded = getCookieValue(USER_DATA_COOKIE);
  if (encoded) {
    const json = decodeBase64(encoded);
    console.log("Load Data: ", json);
    return JSON.parse(json);
  } else {
    return null;
  }
}

function getCookieValue(key) {
  const cookie = document.cookie
    .split("; ")
    .find((cookie) => cookie.startsWith(`${key}=`));

  if (cookie) {
    const value = cookie.replace(`${key}=`, "");
    return value;
  } else {
    return null;
  }
}

function setCookie(key, value, maxAge) {
  const cookie = `${key}=${value};max-age=${maxAge};path=/${cookieOptions()}`;
  document.cookie = cookie;
}
