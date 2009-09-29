<?php
require_once 'dezutes.api.php';

class DezutesClient extends DezutesAPI {
  
  function __construct($subdomain, $api_key) {
    parent::__construct($subdomain, $api_key);
  }
  
  public function getEstates($params = array()){
    return $this -> sendRequest('estates', $params);
  }
  
  public function getEstate($id = 0, $params = array()){
    return $this -> sendRequest("estates/".$id, $params);
  }
  
  public function getEstatePhotos($id = 0, $params = array()){
    return $this -> sendRequest("estates/".$id.'/photos', $params);
  }
  
  public function getEstatesCount($params = array()){
    return $this -> sendRequest("estates_count", $params);
  }
  #Eksportuotu i svetaine NT savivaldybiu sarasiukas
  public function getEstateMunicipalities($params = array()){
    return $this -> sendRequest("municipalities", $params);
  }
  #Eksportuotu i svetaine NT miestu sarasiukas
  public function getEstateCities($params = array()){
    return $this -> sendRequest("cities", $params);
  }
  #Eksportuotu i svetaine NT mikrorajonu sarasiukas
  public function getEstateBlocks($params = array()){
    return $this -> sendRequest("blocks", $params);
  }
  
  public function getProjects($params = array()){
    return $this -> sendRequest("projects", $params);
  }
  
  public function getProjectPhotos($id = 0, $params = array()){
    return $this -> sendRequest("projects/".$id.'/photos', $params);
  }
  
  public function getProjectEstates($id = 0, $params = array()){
    return $this -> sendRequest("projects/".$id.'/estates', $params);
  }
  
  public function getProject($id = 0, $params = array()){
    return $this -> sendRequest("projects/".$id, $params);
  }
}

?>