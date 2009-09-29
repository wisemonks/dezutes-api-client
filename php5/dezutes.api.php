<?php
#2009-08-14 Arturas

class DezutesAPI {
  private $curl;
  private $url = 'http://api.dezutes.lt';
  private $url_api_version = 'v1';
  private $version = '0.1';
  private $allowed_data_formats = array('xml', 'json');
  public $data_format = 'xml';
  
  #$subdomain ir $api_key naudojami autentifikacijai
  function __construct($subdomain, $api_key) {
    $this -> curl = curl_init();
    #nurodom autentifikacijos buda
    curl_setopt($this -> curl, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
    #autentifikacijos duomenys
    curl_setopt($this -> curl, CURLOPT_USERPWD, $subdomain . ":" . $api_key);
    #paprasom, kad su rezultatu grazintu ir headerius. Testavimo sumetimais.
    curl_setopt($this -> curl, CURLOPT_HEADER, false);
    #su uzklausa siunciam ir siokius tokius duomenis apie save. Bendrinei statistikai
    curl_setopt($this -> curl, CURLOPT_USERAGENT, "PHP".phpversion()."/Dezutes ".$this -> version);
    #paprasom, kad geriau rezultata grazintu, o ne tik ji atspausdintu
    curl_setopt($this -> curl, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($this -> curl, CURLOPT_CONNECTTIMEOUT, 10);
  }
  
  #Paprasom, kad rezultatus grazintu pageidaujamu formatu: xml arba json
  public function setDataFormat($format = 'xml'){
    if(in_array($format, $this -> allowed_data_formats)){
      $this -> data_format = $format;
    }
  }
  
  
  protected function sendRequest($controller, $params = array()){
    curl_setopt($this -> curl, CURLOPT_URL, $this -> constructUrl($controller, $params));
    $result = curl_exec($this -> curl);
    $error = curl_error($this -> curl);
    if(!empty($error)){
      throw new Exception("Klaida siunciant uzklausa", curl_error());
    }
    return $result;
  }
  
  private function constructUrl($location = 'estates', $params_hash = array()){
    $url_params = array();
    
    foreach($params_hash as $key => $value){
      #nepriimam tusciu parametru
      if(empty($value)) continue;
      
      if(is_array($value)){
        foreach($value as $val){
          $url_params[] = $key.'[]='.$val;
        }
      }else{
        $url_params[] = $key.'='.$value;
      }
      
    }
    
    $url = $this -> url .'/'. $this -> url_api_version .'/'. $location.'.'.$this -> data_format;
    
    if(sizeOf($url_params) > 0){
      $url .= '?'.implode('&', $url_params);
    }

    return $url;
  }
  
  function __destructor(){
    curl_close($this -> curl);
  }
}
?>
