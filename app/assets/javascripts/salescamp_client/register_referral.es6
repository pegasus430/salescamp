function getParameterByName(name) {
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
  let regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
  results = regex.exec(location.search);
  return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

function registerReferral(jQuery) {
  let token = getParameterByName('salescamp');
  let script = document.querySelector('script[data-salescamp-campaign]');
  let root_url = script.getAttribute("src").split('/').slice(0,-1).join('/');
}

export default registerReferral;
