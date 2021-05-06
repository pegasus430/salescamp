import Client from 'salescamp_client/client';
import loadjQuery from 'salescamp_client/load_jquery';
import registerReferral from 'salescamp_client/register_referral'
loadjQuery(function(jQuery){
  registerReferral();
  let client = new Client(jQuery);
});
