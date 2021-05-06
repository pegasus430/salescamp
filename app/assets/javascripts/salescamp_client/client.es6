import { getParameterByName } from 'salescamp_client/utils';

var CAMPAIGN = {
  PRECAMPAIGN: "precampaign",
  ESTABLISHED: "established"
};

var SALESCAMP = {
  COOKIE_NAME: "salescamp-register-ref",
  SALESCAMP_REFERRAL: "salescamp",
    SALESCAMP_REFERRAL_CREATED: "salescamp_referral"
};

function getSalesCookie () {
  return JSON.parse(readCookie(SALESCAMP.COOKIE_NAME))
}

function getReferCookie () {
  return readCookie(SALESCAMP.SALESCAMP_REFERRAL)
}

function getReferCreatedCookie(){
  return readCookie(SALESCAMP.SALESCAMP_REFERRAL_CREATED);
}

function createCookie(name, value, days) {
    var expires;

    if (days) {
        var date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        expires = "; expires=" + date.toGMTString();
    } else {
        expires = "";
    }
    document.cookie = encodeURIComponent(name) + "=" + encodeURIComponent(value) + expires + "; path=/";
}

function readCookie(name) {
    var nameEQ = encodeURIComponent(name) + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) === ' ') c = c.substring(1, c.length);
        if (c.indexOf(nameEQ) === 0) return decodeURIComponent(c.substring(nameEQ.length, c.length));
    }
    return null;
}

class Client{
  constructor(jQuery){
    let _this = this;
    this.jQuery = jQuery;
    this.script = document.querySelector('script[data-salescamp-campaign]');
    this.root_url = "https:"+this.script.getAttribute("src").split('/').slice(0,-1).join('/');
    this.parseData();
    this.cookieData = getSalesCookie();
    this.referCookie = getReferCookie();
    console.log(this.referCookie);
    this.token = getParameterByName('salescamp');
    let iframe_url = this.root_url + "/campaigns/"+this.campaign_id + "/referred_users/";
    this.post_url = iframe_url;

    var response = '';

    this.jQuery.ajax({ type: "GET",   
             url: this.root_url + "/campaigns/" + this.campaign_id + "/check_subscription/",   
             async: false,
             success : function(text)
             {
                 response = text.status;
             }
    });

    if(response){
      if( !this.cookieData || !this.cookieData.id){
        this.iframe_url = iframe_url+"new";
        this.new = true;
        this.renderViews();
      }else{
        this.jQuery.get(iframe_url+this.cookieData.id,(success)=>{
          this.iframe_url = iframe_url+this.cookieData.id;
          _this.renderViews();
        }).fail(function() {
            _this.iframe_url = iframe_url+"new";
            _this.new = true;
            _this.renderViews();
          });
      }
    }

    this.referCreatedCookie = getReferCreatedCookie();

      if (this.referCookie && !this.referCreatedCookie) {

        createCookie(SALESCAMP.SALESCAMP_REFERRAL_CREATED, "1", 30);

        var refer_inc_url = this.root_url+"/refer_increment/"+this.campaign_id+"/"+this.referCookie;
        
        this.jQuery.get(refer_inc_url);
        
      };
      
  }

  renderViews(){
    if(this.type === CAMPAIGN.PRECAMPAIGN && this.new ){
      this.renderSignup();
    }else{
      this.initModalBtn();
    }
    this.initModal();
    this.attachEvent();
  }
  attachEvent(){
    window.addEventListener
      ? window.addEventListener("message", this.onMessage.bind(this))
      : window.attachEvent("onmessage", this.onMessage.bind(this))
  }

  parseData(){
    let data = this.script.getAttribute('data-salescamp-campaign');
    let dataTokens = data.split(':');
    this.type = (parseInt(dataTokens[1], 10)==0) ? CAMPAIGN.PRECAMPAIGN : CAMPAIGN.ESTABLISHED;
    this.campaign_id = parseInt(dataTokens[0], 10);
    this.campaign_color = this.script.getAttribute('data-salescamp-campaign-color');
  }

  initModal () {
    var modal = this.jQuery('<div>').css({
      position: 'fixed',
      top: '0',
      left: '0',
      width: '100%',
      height: '100%',
      "background-color": "rgba(0, 0, 0, 0.5)",
      "z-index": 2147483645
    });
    var iframe = this.jQuery('<iframe>', {
      name: "salescamp-iframe",
      src: this.iframe_url+'?salescamp='+this.token,
      seamless: 'seamless',
      frameBorder: '0'
    }).css({
      width: '100%',
      height: '100%'
    });
    modal.append(iframe);
    modal.css({'display': 'none'});
    this.jQuery('body').append(modal);
    this.modal = modal;
    this.iframe = iframe;
    return { modal: modal, iframe: iframe };
  }
  initModalBtn(){
    let link = this.jQuery('<a>').css({
          'position': 'fixed',
          'right': '0px',
          'bottom': '0px',
          'margin-right': '20px',
          'margin-bottom': '20px',
          'margin-left': '20px',
          'padding': '1px 8px',
          'border-radius': '15px',
          'box-shadow': '0 0 6px 0 rgba(60, 63, 69, .12)',
          'color': this.campaign_color,
          'border': '1px solid',
          'border-color': this.campaign_color,
          'font-size': '14px',
          'text-align': 'center',
          'text-decoration': 'none',
          'box-sizing': 'border-box',
          'cursor': 'pointer'
        }).addClass("refer_but_hover");

        this.jQuery("<style type='text/css'> .refer_but_hover:hover{ background: "+this.campaign_color+"; color: #fff !important;} </style>").appendTo("head");

        var campaign_hover_color = this.campaign_color;

    var plus = this.jQuery('<div>').css({
      'line-height': '19px'
    })
    plus[0].innerHTML = 'Refer';
    link.append(plus);

    this.jQuery('body').append(link)
    this.button = link;
    link.click(this.onButtonClick.bind(this));
  }
  renderSignup(){
    let form = this.jQuery("<form>", {
      'class': 'salescamp-form-container',
      method: 'POST',
      target: 'salescamp-iframe',
      action: this.post_url
    });
    let email = $("<input>", {
      'class': 'salescamp-email-input',
      'data-salescamp-element': 'email',
      type: 'email',
      name: 'referred_user[email]'
    });
    let token = $("<input>", {
      'class': 'salescamp-token',
      'data-salescamp-element': 'email',
      type: 'hidden',
      name: 'referred_user[token]',
      value: this.token
    });
    let submitBtn = $("<button>", {
      'data-salescamp-element': 'submit',
      type: 'submit'
    })
    .append("<span>Sign up</span>");
    let that = this;
    form.append(email);
    form.append(token);
    form.append(submitBtn);
    this.jQuery(this.script).after(form);
    submitBtn.click(function (e) {
      if (form[0].checkValidity()) {
        that.openModal();
      }
    })
  }

  onButtonClick(event){
    this.openModal();
  }
  onMessage(e){
    console.log(e.data, e.type, e.origin, this.root_url);
    console.log(e.origin.split(':').slice(1).join(''));
    if (e.origin === this.root_url) {
      try {
        var obj = JSON.parse(e.data);
        console.log(obj.type, obj.data);
        if (obj.type === 'closeModal') {
          this.modal.css({'display': 'none'});
        }
        else if (obj.type === 'saveItem') {
          var data = obj.data;
          createCookie(SALESCAMP.COOKIE_NAME, JSON.stringify({ id: data.id }));
          this.cookieData = getSalesCookie();
        }
      }
      catch (err) {
      }
    }
  }
  openModal(){
    this.modal.css({'display': 'block'})
  }
}
export default Client;
