# = API dokumentacijos intro
#
# Dežutės.lt - NT valdymo įrankis.
# Šio dokumento esmė paaiškinti kokiais būdais vyksta apsikeitimai tarp Dežutės.lt sistemos ir kliento(nt agentūros) svetainės.
# 
# = Duomenų apsikeitimas
#
# Duomenų apsikeitimas vyksta REST principu. Šiuo metu pilnai palaikomas tik GET metodas(ateityje planuojamas POST/PUT/DELETE metodu realizavimas).
# Duomenis atiduodami XML ir JSON formatu. 
# Naudotojai identifikuojami Auth Basic principu. 
# Vartotojo vardas naudojamas Dezutes.lt įmonės subdomainas pvz. *wisemonks*.dezutes.lt.
# Slaptažodis - api_key raktas(md5 string), sugeneruotas Dezutes.lt sistemos. 


require 'rubygems'
require 'httparty'

# = API dokumentacijos intro
#
# Dežutės.lt - NT valdymo įrankis.
# Šio dokumento esmė paaiškinti kokiais būdais vyksta apsikeitimai tarp Dežutės.lt sistemos ir kliento(nt agentūros) svetainės.
# 
# = Duomenų apsikeitimas
#
# Duomenų apsikeitimas vyksta REST principu. Šiuo metu pilnai palaikomas tik GET metodas(ateityje planuojamas POST/PUT/DELETE metodu realizavimas).
# Duomenis atiduodami XML ir JSON formatu. 
# Naudotojai identifikuojami Auth Basic principu. 
# Vartotojo vardas naudojamas Dezutes.lt įmonės subdomainas pvz. *wisemonks*.dezutes.lt.
# Slaptažodis - api_key raktas(md5 string), sugeneruotas Dezutes.lt sistemos.

class Dezutes
  include HTTParty
  
  base_uri 'http://api.dezutes.lt/v1'
  
  def initialize(subdomain, api_key)
    @auth = {:username => subdomain, :password => api_key}
  end
  
  # Metodas skirtas NT objektu sarasui gauti.
  # Grąžinamą sąrašą galimę filtruoti pagal metodui perduodamus parametrus.
  # 
  # ==== Duomenų filtravimo parametrai:
  # - estate_type   |   type:option, values=commercial, house, flat, site |  NT tipas. Galima nurodyti kelis tipus, pvz. estate_type=commercial,site
  # - broker  | type:integer  | Brokerio ID
  # - municipality | type:integer | Savialdybė
  # - city | type:integer | Miesto ID
  # - block | type:integer | Mikrorajono ID
  # - street | type:varchar | Gatvės paieška pagal pavadinimą ar pavadinimo dalį
  # - project | type:integer | Projekto ID
  # - belongs_to_project | type: boolean | Tik tie kurie yra priskirti projektui. Naudojamas, tais atvejais kai norima gauti visus Projektams priklausančius objektus
  # - area_from | type:float | Plotas nuo
  # - area_till | type:float | Plotas iki
  # - for_sale | type:boolean | Ar NT parduodamas? | for_sale=1
  # - for_rent | type:boolean | Ar NT nuomojamas? | for_rent=1
  # - operation | type:option values = for_sale, for_rent | Alternatyvus nurodymas gauti parduodamus ar nuomojamus objektus | operation=for_sale
  # - status | type:integer | Objekto statusas Dežutėse. Objektų sąrašo gavimas žiūr. į metodą get_estate_statuses
  # - price_from | type:float | Kaina nuo(imtinai) | price_from=400000
  # - price_till | type:float | Kaina iki(imtinai)
  # - rooms | type:float | Tikslus kamb.sk. Pvz. rooms=3 - rasti NT objektus su 3 kambariais/patalpomis.
  # - room_count_from | type:integer | Kambarių skaičius nuo(imtinai).
  # - room_count_till | type:integer | Kambarių skaičius iki(imtinai).
  # - floor_count_from | type:integer | Aukštų skaičius pastate nuo(imtinai).
  # - floor_count_till | type:integer | Aukštų skaičius pastate iki(imtinai).
  # - floor_from | type:integer | Buto ar patalpų aukštas nuo(imtinai).
  # - floor_till | type:integer | Buto ar patalpų aukštas iki(imtinai).
  # - year_from | type:integer | Pastato statybos metai nuo(imtinai).
  # - year_till | type:integer | Pastato statybos metai iki(imtinai).
  # - purpose | type:varchar | Komercinio objekto arba sklypo paskirtis
  # - purposes | type:array| Komercinio objekto paskirtys pvz. Rasti sandėliavimo IR gamybinės patalpas - purposes=purpose_store,purpose_manufacture 
  # - purposes_join | type: option, values = or, and. Komercinio objektų pagal paskirtis užklausos formavimo nustatymas. Pvz. Užklausa 'purposes=purpose_store,purpose_manufacture&purposes_join=or' grąžins sandėliavimo ARBA gamybinės patalpas
  #
  # ==== Duomenų ribojimo, puslapiavimo parametrai:
  # - per_page | type:integer, max=100 | Grąžinamų NT objektų kiekis. 
  # - page | type:integer | Puslapio nr. SQL offset t.y.  sql išraiška 'LIMIT 10 OFFSET 10' yra lygi parametrams 'page = 2, per_page = 10'
  # 
  # ==== Duomenų rūšiavimas, rūšiavimo kryptis:
  # - sort_by | type: option, default=date | Rūšiuoti pagal:
  #   - location - vietą
  #   - area - plotą
  #   - broker - brokerio vardą,pavardę
  #   - sale_price - pardavimo kainą
  #   - rent_price - nuomos kainą
  #   - square_sale_price - kv.m. pardavimo kainą
  #   - square_rent_price - k.m. nuomos kainą
  #   - date - sukūrimo datą
  #   - floor - aukštą
  #   - floor_count - aukštų skaičių
  #   - site_area - sklypo plotą. Tinka tik kai estate_type=house
  #   - rand - atsitiktine tvarka
  # 
  # - sort_to | type: option, default=desc | Rūšiavimo kryptis:
  #   - asc 
  #   - desc
  # 
  # ==== Spec.parametrai
  # - extended_info | type:boolean, default=0 | Išplėstinė objektų informacija
  # - description_lang | type:string | Aprašymo kalba (kai kurios agentūros saugo NT objektus keliomis kalbomis) pvz. description_lang=en
  # - photo_version | type:option, default=original | Nuotraukos versija. Visos nuotraukų versijos žiūr. į get_estate_photo_versions
  #
  # ==== Užklausos pvz:
  #     #50 pigiausi praduodami butai Vilniaus mieste
  #     get_estates(:estate_type => 'flat', :for_sale => 1, :city => 1, :per_page = 50, :sort_by => 'price', :sort_to => 'asc')
  #
  #     #20 naujausių nuomojamų kom.patalpų pasiūlymų, didesnių nei 50 kv.m.
  #     get_estates(:estate_type => 'commercial', :for_rent => 1, :per_page => 20, :sort_by => 'date')
  #
  def get_estates(*args)
    send_request("/estates", *args)
  end
  
  # Gražinamas konkretus NT objektas, pagal ID
  #
  # ==== Spec.parametrai
  # - photo_version | type:option, default=original | Nuotraukos versija. Grąžinama tik viena pagrindinė objekto nuotrauka. Visos nuotraukų versijos žiūr. į get_estate_photo_versions
  #
  # ==== Užklausos pvz:
  #     get_estate(76943, {:photo_version => 'site_thumb'})
  def get_estate(id, *args)
    send_request("/estate/#{id}", *args)
  end
  
  # *Visos* konkretaus NT objekto nuotraukos
  #
  # ==== Spec.parametrai
  # - photo_versions | type:array of options, default=[original] | Pageidaujamos nuotraukų versijos. Visos nuotraukų versijos žiūr. į get_estate_photo_versions
  # - limit | type:integer | Nuotraukų skaičius
  #
  # ==== Užklausos pvz:
  #     get_estate_photos(16252, {:photo_versions => ['site_thumb', 'original']})
  def get_estate_photos(id, *args)
    send_request("/estates/#{id}/photos", *args);
  end
  
  # Metodas skirtas NT objektų kiekiui grąžinti
  #
  # Kiekis grąžinamas pagal 'Duomenų filtravimo parametrus' nurodytus metode get_estates
  #
  # ==== Užklausos pvz:
  #     #Parduodamų, brangesnių nei milijonas litų, sklypų kiekis
  #     get_estate_photos(:estate_type => 'site', :for_sale => 1, :sale_price_from => 1000000)
  def get_estate_count(*args)
    send_request("/estates_count", *args)
  end
  
  # Savivaldybių sąrašas
  #
  # Grąžinamas tik realus savivaldybių sąrašas t.y. tik tos savialdybės, kurios turi sąryšius su NT objektais
  # 
  # Rezultatą galime filtruoti pagal get_estates metodo parametrus
  #
  # ==== Užklausos pvz:
  #
  #     #Visos savivaldybės, kuriose turime namų
  #     get_estate_municipalities(:estate_type => 'house')
  def get_estate_municipalities(*args)
    send_request("/municipalities", *args)
  end
  
  # Miestų/gyvenviečių sąrašas
  #
  # Grąžinamas tik realus miestų sąrašas t.y. tik tie miestai, kurios turi sąryšius su NT objektais
  # 
  # Rezultatą galime filtruoti pagal get_estates metodo parametrus
  #
  # ==== Užklausos pvz:
  #
  #     #Visi Vilniaus savivaldybės miestai
  #     get_estate_cities(:municipality => 461)
  def get_estate_cities(*args)
    send_request("/cities", *args)
  end
  
  # Mikrorajonų sąrašas
  #
  # Grąžinamas tik realus mikrorajonų sąrašas t.y. tik tie mikrorajonai, kurios turi sąryšius su NT objektais
  # 
  # Rezultatą galime filtruoti pagal get_estates metodo parametrus
  #
  # ==== Užklausos pvz:
  #
  #     #Visi Kauno miesto mikrorajonai
  #     get_estate_blocks(:city => 2)
  def get_estate_blocks(*args)
    send_request("/blocks", *args)
  end
  
  # Projektų sąrašas
  # Grąžinamą sąrašą galimę filtruoti pagal metodui perduodamus parametrus.
  # 
  # ==== Duomenų filtravimo parametrai:
  # - municipality | type:integer | Savialdybė
  # - city | type:integer | Miesto ID
  # - is_investment | type:boolean(integer: 0 || 1) | Investiciniai projektai
  # - is_living | type:boolean(integer: 0 || 1) | Gyvenamajieji projektai
  # - is_commercial | type:boolean(integer: 0 || 1) | Komerciniai projektai
  # 
  #  Projektas gali buti ir investicinis, ir komercinis, ir gyvenamasis
  #
  # ==== Užklausos pvz:
  #
  #     #Visi Vilniaus miesto Investiciniai Komerciniai projektai
  #     get_estate_blocks(:city => 1, :is_investment => 1, :is_commercial => 1)
  #
  def get_projects(*args)
    send_request("/projects", *args)
  end
  
  # Gražinamas konkretus NT projektas, pagal ID
  #
  # ==== Spec.parametrai
  # - photo_version | type:option, default=original | Nuotraukos versija. Grąžinama tik viena pagrindinė projekto nuotrauka. Visos nuotraukų versijos žiūr. į get_estate_photo_versions
  #
  # ==== Užklausos pvz:
  #     get_project(76943, {:photo_version => 'index'})
  #
  def get_project(id, *args)
    send_request("/projects/#{id}", *args)
  end
  
  # *Visos* konkretaus NT projekto nuotraukos
  #
  # ==== Spec.parametrai
  # - photo_versions | type:array of options, default=[original] | Pageidaujamos nuotraukų versijos. Visos nuotraukų versijos žiūr. į get_project_photo_versions
  #
  # ==== Užklausos pvz:
  #     get_estate_photos(16252, {:photo_versions => ['site_thumb', 'original']})
  def get_project_photos(id, *args)
    send_request("/projects/#{id}/photos", *args)
  end
  
  # NT objektų sąrašas, kurie priskirti prie konkretaus projekto
  #
  # Rezultatą galime filtruoti pagal get_estates metodo parametrus
  #
  # ==== Užklausos pvz:
  #     #NT projekto objektai, brangesni nei 1 milijonas
  #     get_project_estates(234, {:sale_price_from => 1000000})
  #
  def get_project_estates(id, *args)
    send_request("/projects/#{id}/estates", *args)
  end
  
  # NT objektų statusų sąrašas
  def get_estate_statuses
    send_request("/estate_statuses")
  end
  
  # NT objektų nuotraukų versijų sąrašas
  def get_estate_photo_versions
    send_request("/estate_photo_versions")
  end
  # NT projektų nuotraukų versijų sąrašas
  def get_project_photo_versions
    send_request("/project_photo_versions")
  end
  
  # Brokerių sąrašas
  #
  # ==== Duomenų rūšiavimas, rūšiavimo kryptis:
  # - sort_by | type: option, default=name | Rūšiuoti pagal:
  #   - name - vardą
  #   - phone - telefono numerį
  #   - email - el.paštą
  #
  # - sort_to | type: option, default=asc | Rūšiavimo kryptis:
  #   - asc 
  #   - desc
  #
  def get_brokers(*args)
    send_request("/brokers", *args)
  end
  #Brokerio informacija
  def get_broker(id)
    send_request("/brokers/#{id}")
  end
  
  protected
  def send_request(resource_location, *args)
    response_type = args.first.is_a?(Symbol) ? args.shift : :xml
    options = (args.last.is_a?(Hash) ? args.pop : {}).merge!(
    {
      :basic_auth => @auth,
      :api_key => @auth[:password]
    })
    self.class.get(resource_location.concat(".#{response_type}"), options)
  end
  
end