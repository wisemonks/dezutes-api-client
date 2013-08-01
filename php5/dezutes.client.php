<?php
require_once 'dezutes.api.php';

class DezutesClient extends DezutesAPI {
  
  function __construct($subdomain, $api_key) {
    parent::__construct($subdomain, $api_key);
  }
  /*
   Metodas skirtas NT objektu sarasui gauti.
   Per masyva $params perduodam salygos parametrus Dezutems
   $params["estate_type"] = 'commercial'; 
    'commercial' - komercine patalpos
    'house' - namai;
    'flat' - butai;
    'site' - sklypai;
   $params["municipality"] = 461; Integer; Savivaldybes ID;
   $params["city"] = 1; Integer; Miesto ID;
   $params["block"] = 34; Integer; Mikrorajono ID;
   $params["street"] = 2342; Integer; Gatves ID;
   $params["project"] = 12; Integer; Projekto ID; Ziur. i 
   $params["area_from"] = 23.45; Float; Plotas nuo;
   $params["area_from"] = 43; Float; Plotas iki;
   $params["for_sale"] = 1; Bool/Integer; Operacijos tipas. Pardavimas;
   $params["for_rent"] = 1; Bool/Integer; Operacijos tipas. Pardavimas;
   $params["status"] = 34; Integer; Objekto eilė. Objektu eiles sudarineja pats klientas: Aktyvus, Rezervuotas, Parduotas ir t.t.
   $params["rooms"] = 2; Integer; Kambariu skaicius;
   $params["room_count_from"] = 1; Integer; Kambariu skaiciuos nuo;
   $params["room_count_from"] = 2; Integer; Kambariu skaiciuos iki;
   
   $params["floor_count_from"] = 1; Integer; Pastato aukstu skaicius nuo;
   $params["floor_count_till"] = 2; Integer; Pastato aukstu skaicius iki;
   
   $params["floor_from"] = 2; Integer; Patalpos/buto aukstas nuo;
   $params["floor_till"] = 3; Integer; Patalpos/buto aukstas iki;
   
   $params["year_from"] = 1999; Integer; Pastatato statybos metai nuo;
   $params["year_till"] = 2004; Integer; Pastatato statybos metai iki;
   
   $purpose['purpose'] = array('purpose_office') || '';
   Komerciniu patalpu atveju Array tipas;
    purpose_office: Administracinės
    purpose_manufacture: Gamybinės
    purpose_store: Sandėliavimo
    purpose_buisness: Prekybos
    purpose_food: Maitinimo
    purpose_building: Pastatas
    purpose_other: Kitos paskirties
    
   Sklypu atveju String tipas:
    commercial: Komercinė
    agriculture: Žemės ūkio
    forest: Miškų ūkio
    residential_skyscraper: Daugiaaukštė gyvenamoji
    residential: Namų valda
    manufacturing: Pramonės/sandėliavimo/prekybos
    recreation: Rekreacinės
    garden: Sodų
  */
  public function getEstates($params = array()){
    return $this -> sendRequest('estates', $params);
  }
  
  /*
    Metodas grazina konkreciam NT objektui gauti
  */
  public function getEstate($id = 0, $params = array()){
    return $this -> sendRequest("estates/".$id, $params);
  }
  /*
    Metodas grazina konkretaus NT objekto nuotraukas
  */
  public function getEstatePhotos($id = 0, $params = array()){
    return $this -> sendRequest("estates/".$id.'/photos', $params);
  }
  
  /*
    Metodas grazina objektu kiekiui gauti, pagal parametrus(ziur. i getEstates metoda)
  */
  public function getEstatesCount($params = array()){
    return $this -> sendRequest("estates_count", $params);
  }
  /*
  Metodas pagal parametrus grazina visas Savivaldybes. Grazinamos tik tos, kurios turi sarysi su NT objektais
  $params - ziur. i getEstates
  */
  public function getEstateMunicipalities($params = array()){
    return $this -> sendRequest("municipalities", $params);
  }
  /*
   Metodas pagal parametrus grazina visus Miestus. Grazinamos tik tie, kurie turi sarysi su NT objektais
   $params - ziur. i getEstates
   */
  public function getEstateCities($params = array()){
    return $this -> sendRequest("cities", $params);
  }
  /*
   Metodas pagal parametrus grazina visus MikroRajonus. Grazinamos tik tie, kurie turi sarysi su NT objektais
   $params - ziur. i getEstates
   */
  public function getEstateBlocks($params = array()){
    return $this -> sendRequest("blocks", $params);
  }
  
  # NT objektų statusai
  public function getEstateStatuses(){
    return $this -> sendRequest("estate_statuses");
  }
  
  # NT objektų nuotraukų versijų sąrašas
  public function getEstatePhotoVersions(){
     return $this -> sendRequest("estate_photo_versions");
   }

  /*
   Metodas grazina projektus.
   */
  public function getProjects($params = array()){
    return $this -> sendRequest("projects", $params);
  }
  /*
   Metodas grazina konkretu projekta.
   */
  public function getProject($id = 0, $params = array()){
    return $this -> sendRequest("projects/".$id, $params);
  }
  /*
    Metodas grazina konkretaus projekto nuotraukas.
  */
  public function getProjectPhotos($id = 0, $params = array()){
    return $this -> sendRequest("projects/".$id.'/photos', $params);
  }
  /*
    Metodas grazina konkreciam projektui priskirtus NT objektus.
  */
  public function getProjectEstates($id = 0, $params = array()){
    return $this -> sendRequest("projects/".$id.'/estates', $params);
  }
  
  # NT projektų nuotraukų versijų sąrašas
   public function getProjectsPhotoVersions(){
      return $this -> sendRequest("project_photo_versions");
  }
  #Brokerio informacija
  public function getBroker($id = 0, $params = array()){
     return $this -> sendRequest("brokers/".$id, $params);
   }
   
  #Brokerių sąrašas
  public function getBrokers($params = array()){
    return $this -> sendRequest("brokers", $params);
  }

  #Ofisų sąrašas
  public function getOffices($params = array()){
    return $this -> sendRequest("offices", $params);
  }
  
  
}

?>