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
  # - statuses | type:array | Pagal kelis objektų statusus | statuses
  # - price_from | type:float | Kaina nuo(imtinai) | price_from=400000
  # - price_till | type:float | Kaina iki(imtinai)
  # - square_price_from | type:float | Kv. m kaina nuo(imtinai) | square_price_from=400000
  # - square_price_till | type:float | Kv. m kaina iki(imtinai)
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
  # - house_building_type | type:string | Pagal namo tipą.
  # - new_estate | type:boolean | Tinklapio nustatymai "Naujas objektas" | new_estate=1
  # - top_estate | type:boolean | Tinklapio nustatymai "Top objektas" | top_estate=1
  # - projects | type:array | Objektų filtravimas pagal priskirtus projektus | projects=25,27
  # - belongs_to_project | type:boolean | Objektai priklausantis projektams, nenurodant projektų id | belongs_to_project=1
  # - no_project | type:boolean | Objektai nepriklausantis projektams | no_project=1
  # - latitude | type:float | Paieška pagal platumą. Naudoti kartu su longitude
  # - longitude | type:float | Paieška pagal ilgumą. Naudoti kartu su latitude
  # - radius | type:integer | default=1 | Paieškos spindulio (km) parametras ilgumai, platumai. 
  # ==== Buto specifiniai atributai:
  # - flat_has_high_ceiling | type:boolean | Aukštos lubos | flat_has_high_ceiling=1
  # - flat_has_balcony | type:boolean | Balkonas | flat_has_balcony=1
  # - flat_has_kitchen | type:boolean | Buitinė technika | flat_has_kitchen=1
  # - flat_has_with_second_floor | type:boolean | Butas per kelis aukštus | flat_has_with_second_floor=1
  # - flat_has_detail_plan | type:boolean | Detalus planas | flat_has_detail_plan=1
  # - flat_has_internet | type:boolean | Internetas | flat_has_internet=1
  # - flat_has_cable_tv | type:boolean | Kabelinė televizija | flat_has_cable_tv=1
  # - flat_has_keylocked_stairway | type:boolean | Kodinė laiptinės spyna | flat_has_keylocked_stairway=1
  # - flat_has_conditioning | type:boolean | Kondicionierius | flat_has_conditioning=1
  # - flat_has_packet_windows | type:boolean | Langai su stiklo paketais | flat_has_packet_windows=1
  # - flat_has_lift | type:boolean | Liftas | flat_has_lift=1
  # - flat_has_parquet | type:boolean | Parketas | flat_has_parquet=1
  # - flat_has_dressing_room | type:boolean | Rūbinė | flat_has_dressing_room=1
  # - flat_has_basement | type:boolean | Rūsys | flat_has_basement=1
  # - flat_has_lumber_room | type:boolean | Sandėliukas | flat_has_lumber_room=1
  # - flat_has_alarm | type:boolean | Signalizacija | flat_has_alarm=1
  # - flat_has_wahing_machine | type:boolean | Skalbimo mašina | flat_has_wahing_machine=1
  # - flat_has_furniture | type:boolean | Su baldais | flat_has_furniture=1
  # - flat_has_phone | type:boolean | Telefono linija | flat_has_phone=1
  # - flat_has_tv | type:boolean | Televizorius | flat_has_tv=1
  # - flat_has_terrace | type:boolean | Terasa | flat_has_terrace=1
  # - flat_has_wc_bath_separate | type:boolean | Tualetas ir vonia atskirai | flat_has_wc_bath_separate=1
  # - flat_has_parking_place | type:boolean | Vieta automobiliui | flat_has_parking_place=1
  # - flat_has_open_kitchen | type:boolean | Virtuvė sujungta su kamb. | flat_has_open_kitchen=1
  # - flat_has_bath | type:boolean | Vonia | flat_has_bath=1
  # - flat_has_refridgerator | type:boolean | Šaldytuvas | flat_has_refridgerator=1
  # - flat_has_armed_doors | type:boolean | Šarvuotos durys | flat_has_armed_doors=1
  # - flat_has_fireside | type:boolean | Židinys | flat_has_fireside=1
  # - flat_heating | type:Array | Šildymas | flat_heating[]=central&flat_heating[]=electric | Galimos reikšmės:
  #   - central | Centrinis
  #   - city | Centrinis-kolektorinis
  #   - gas | Dujinis
  #   - electric | Elektrinis
  #   - solid_fuel | Kietu kuru
  #   - geo | Geoterminis
  # - flat_equipment | type:Array | Įrengimas | flat_equipment[]=full | Galimos reikšmės:
  #   - full | Visa apdaila
  #   - part | Dalinė apdaila
  #   - partial_repairs | Suremontuotas
  #   - good | Tvarkingas
  #   - need_repairs | Remontuotinas
  #   - other | Kita
  # ==== Namo specifiniai atributai:
  # - house_has_water_pool | type:boolean | Baseinas | house_has_water_pool=1
  # - house_has_boiler | type:boolean | Boileris | house_has_boiler=1
  # - house_has_kitchen | type:boolean | Buitinė technika | house_has_kitchen=1
  # - house_has_detail_plan | type:boolean | Detalus planas | house_has_detail_plan=1
  # - house_has_gas | type:boolean | Dujos | house_has_gas=1
  # - house_has_shower | type:boolean | Dušas | house_has_shower=1
  # - house_has_electricity | type:boolean | Elektra | house_has_electricity=1
  # - house_has_electricity_380V | type:boolean | Elektra 3x380V | house_has_electricity_380V=1
  # - house_has_good_access | type:boolean | Geras privažiavimas | house_has_good_access=1
  # - house_has_internet | type:boolean | Internetas | house_has_internet=1
  # - house_has_cable_tv | type:boolean | Kabelinė televizija | house_has_cable_tv=1
  # - house_has_conditioning | type:boolean | Kondicionierius | house_has_conditioning=1
  # - house_has_packet_windows | type:boolean | Langai su stiklo paketais | house_has_packet_windows=1
  # - house_has_outdoor_terrace | type:boolean | Lauko terasa | house_has_outdoor_terrace=1
  # - house_has_lift | type:boolean | Liftas | house_has_lift=1
  # - house_has_city_plumbing | type:boolean | Miesto kanalizacija | house_has_city_plumbing=1
  # - house_has_parquet | type:boolean | Parketas | house_has_parquet=1
  # - house_has_bathhouse | type:boolean | Pirtis | house_has_bathhouse=1
  # - house_has_dressing_room | type:boolean | Rūbinė | house_has_dressing_room=1
  # - house_has_basement | type:boolean | Rūsys | house_has_basement=1
  # - house_has_alarm | type:boolean | Signalizacija | house_has_alarm=1
  # - house_has_wahing_machine | type:boolean | Skalbimo mašina | house_has_wahing_machine=1
  # - house_has_furniture | type:boolean | Su baldais | house_has_furniture=1
  # - house_has_phone | type:boolean | Telefono linija | house_has_phone=1
  # - house_has_tv | type:boolean | Televizorius | house_has_tv=1
  # - house_has_wc_bath_separate | type:boolean | Tualetas ir vonia atskirai | house_has_wc_bath_separate=1
  # - house_has_water | type:boolean | Vandentiekis | house_has_water=1
  # - house_has_local_plumbing | type:boolean | Vietinė kanalizacija | house_has_local_plumbing=1
  # - house_has_open_kitchen | type:boolean | Virtuvė sujungta su kamb. | house_has_open_kitchen=1
  # - house_has_bath | type:boolean | Vonia | house_has_bath=1
  # - house_has_wavin_pipes | type:boolean | Wavin vamzdžiai | house_has_wavin_pipes=1
  # - house_has_refridgerator | type:boolean | Šaldytuvas | house_has_refridgerator=1
  # - house_has_near_water | type:boolean | Šalia vandens tvenkinio | house_has_near_water=1
  # - house_has_armed_doors | type:boolean | Šarvuotos durys | house_has_armed_doors=1
  # - house_has_fireside | type:boolean | Židinys | house_has_fireside=1med_doors=1
  # - house_has_fireside | type:boolean | Židinys | flat_has_fireside=1
  # - house_heating | type:Array | Šildymas | house_heating[]=central | Galimos reikšmės:
  #   - central | Centrinis
  #   - gas |Dujinis
  #   - electric | Elektrinis
  #   - solid_fuel | Kietu kuru
  #   - liquid_fuel | Skystu kuru
  #   - geo | Geoterminis
  #   - other | Kita
  # - house_equipment | type:Array | Įrengimas | house_equipment[]=full | Galimos reikšmės:
  #   - full | Pilnai įrengtas
  #   - part | Dalinė apdaila
  #   - roofed_box | Neįrengtas/Statomas
  #   - other | Kita
  # ==== Komercinių patalpų specifiniai atributai:
  # - commercial_has_security | type:boolean | Apsauga | commercial_has_security=1
  # - commercial_has_separate_entryway | type:boolean | Atskiras įėjimas | commercial_has_separate_entryway=1
  # - commercial_has_balcony | type:boolean | Balkonas | commercial_has_balcony=1
  # - commercial_has_kitchen | type:boolean | Buitinė technika | commercial_has_kitchen=1
  # - commercial_has_detail_plan | type:boolean | Detalus planas | commercial_has_detail_plan=1
  # - commercial_has_gas | type:boolean | Dujos | commercial_has_gas=1
  # - commercial_has_shower | type:boolean | Dušas | commercial_has_shower=1
  # - commercial_has_electricity | type:boolean | Elektra | commercial_has_electricity=1
  # - commercial_has_good_access | type:boolean | Geras privažiavimas | commercial_has_good_access=1
  # - commercial_has_internet | type:boolean | Internetas | commercial_has_internet=1
  # - commercial_has_conference_hall | type:boolean | Konferencijų salė pastate | commercial_has_conference_hall=1
  # - commercial_has_cargo_elevator | type:boolean | Krovininis liftas | commercial_has_cargo_elevator=1
  # - commercial_has_lift | type:boolean | Liftas | commercial_has_lift=1
  # - commercial_has_local_feeding | type:boolean | Maitinimo įstaiga pastate | commercial_has_local_feeding=1
  # - commercial_has_room_conditioning | type:boolean | Patalpų kondicionavimas | commercial_has_room_conditioning=1
  # - commercial_has_alarm | type:boolean | Signalizacija | commercial_has_alarm=1
  # - commercial_has_furniture | type:boolean | Su baldais | commercial_has_furniture=1
  # - commercial_has_phone | type:boolean | Telefono linija | commercial_has_phone=1
  # - commercial_has_water | type:boolean | Vandentiekis | commercial_has_water=1
  # - commercial_heating | type:Array | Šildymas | commercial_heating[]=central| Galimos reikšmės:
  #   - central | Centrinis
  #   - city | Miesto
  #   - gas |Dujinis
  #   - electric | Elektrinis
  #   - solid_fuel | Kietu kuru
  #   - liquid_fuel | Skystu kuru
  #   - geo | Geoterminis
  #   - other | Kita
  # - commercial_equipment | type:Array | Įrengimas | commercial_equipment[]=full | Galimos reikšmės:
  #   - full | Pilnai įrengtas
  #   - part | Dalinė apdaila
  #   - no_equipment | Neįrengtas
  # ==== Duomenų ribojimo, puslapiavimo parametrai:
  # - per_page | type:integer, max=250 | Grąžinamų NT objektų kiekis.
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
  #   - edit_time - redagavimo datą
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
  #     #Bendras butu ir namu kiekis
  #     get_estate_count(:estate_type => 'flat,house')
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
  # - is_logistic | type:boolean(integer: 0 || 1) | Logistikos projektai
  # - has_flat | type:boolean(integer: 0 || 1) | Rodyti prie projekto priskirtus butus
  # - has_house | type:boolean(integer: 0 || 1) | Rodyti prie projekto priskirtus namus
  # - has_site | type:boolean(integer: 0 || 1) | Rodyti prie projekto priskirtus sklypus
  # - has_commercial | type:boolean(integer: 0 || 1) | Rodyti prie projekto priskirtus kom. patalpas
  # - area_from | type:float | NT projekto plotas nuo
  # - area_till | type:float | NT projekto plotas iki  
  # - price_from | type:float | NT projekto kaina nuo
  # - price_till | type:float | NT projekto kaina iki
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

  # Metodas skirtas NT projektų kiekiui grąžinti
  #
  # Kiekis grąžinamas pagal 'Duomenų filtravimo parametrus' nurodytus metode get_projects
  #
  # ==== Užklausos pvz:
  #     #Bendras NT projektu kiekis
  #     get_project_count
  def get_project_count(*args)
    send_request("/projects_count", *args)
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

  #Ofisų sąrašas
  def get_offices(*args)
    send_request("/offices", *args)
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
