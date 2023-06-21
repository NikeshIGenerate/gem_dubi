const kVehicleTypes = {
  'Alfa Romeo': [
    '147',
    '156',
    '166',
    'Giulia',
    'Giulietta',
    'Mito',
    'Spider',
    'Stelvio',
    'Other'
  ],
  'Aston Martin': ['DB', 'Rapide S', 'Vanquish', 'Vantage', 'Other'],
  'Audi': [
    '100',
    '80',
    'A1',
    'A3',
    'A4',
    'A5',
    'A6',
    'A7',
    'A8',
    'Q2',
    'Q3',
    'Q5',
    'Q7',
    'R8',
    'S3/RS3',
    'TT',
    'Other'
  ],
  'BMW': [
    '116',
    '118',
    '120',
    '218',
    '316',
    '318',
    '320',
    '325',
    '328',
    '330',
    '335',
    '340',
    '418',
    '518',
    '520',
    '523',
    '525',
    '528',
    '530',
    '535',
    '540',
    '545',
    '550',
    '630',
    '640',
    '645',
    '650',
    '730',
    '735',
    '740',
    '745',
    '750',
    '850',
    'M3',
    'M5',
    'M8',
    'X1',
    'X2',
    'X3',
    'X4',
    'X5',
    'X6',
    'Z3',
    'Z4',
    'Other'
  ],
  'BYD': ['F0', 'F3', 'Flyer', 'L3', 'S5', 'Other'],
  'Baic': ['X3', 'X5', 'X7', 'Other'],
  'Bentley': [
    'Arnage',
    'Bentayga',
    'Continental',
    'Flying Spur',
    'Mulsanne',
    'Other'
  ],
  'Bestune': ['B70', 'T33', 'T55', 'T77 Pro', 'Other'],
  'Brilliance': [
    'FRV',
    'FRV Cross',
    'FSV',
    'Galena',
    'H',
    'Jinbei',
    'S30',
    'Shineray',
    'Splendor',
    'V3',
    'H530',
    'V5',
    'X30',
    'Other'
  ],
  'Bugatti': ['Chiron', 'Veyron'],
  'Buick': [
    'Apollo',
    'Century',
    'Gran Sport',
    'Lesabre',
    'Oldsmobile',
    'Park Avenue',
    'Regal',
    'Skylark',
    'Other'
  ],
  'Cadillac': [
    'Brougham',
    'Deville',
    'DTS',
    'Eldorado',
    'Escalade',
    'Fleetwood',
    'SRX',
    'Other'
  ],
  'Chana': ['Benni', 'New Star', 'Other'],
  'Changan': ['Benni mini', 'CS35', 'V7', 'Alsvin', 'EADO', 'CS15', 'CS55'],
  'Changhe': ['Ideal', 'M50', 'Q35', 'Super Panda', 'Other'],
  'Chery': [
    'A11',
    'A15',
    'Arrizo 5',
    'Envy',
    'Long',
    'QQ',
    'Tiggo',
    'Tiggo 4',
    'Other'
  ],
  'Chevrolet': [
    'Astro',
    'Aveo',
    'Blazer',
    'Camaro',
    'Caprice',
    'Captiva',
    'Corsica',
    'Corvette',
    'Cruze',
    'Epica',
    'Equinox',
    'Frontera',
    'Impala',
    'Lanos',
    'Lumina',
    'Malibu',
    'N200',
    'N300',
    'Optra',
    'Pickup/Dababa',
    'Silverado',
    'Sonic',
    'Spark',
    'Sprint',
    'Suburban',
    'Tahoe',
    'Trailblazer',
    'Traverse',
    'Uplander',
    'Vega',
    'Other'
  ],
  'Chrysler': [
    'C300',
    'Concorde',
    'Crossfire',
    'M300',
    'Neon',
    'Pacifica',
    'PT Cruiser',
    'Sebring',
    'Stratus',
    'Town and Country',
    'Voyager/Caravan',
    'Other'
  ],
  'Citroen': [
    'AX',
    'Berlingo',
    'C-Elysée',
    'C3',
    'C3 Picasso',
    'C4',
    'C4 Grand Picasso',
    'C4 Picasso',
    'C5',
    'C6',
    'C8',
    'DS3',
    'DS4',
    'DS5',
    'DS7',
    'Jumpy',
    'Oltcit',
    'Picasso',
    'Xanita',
    'Xsara',
    'Xsara Picasso',
    'ZX',
    'Other'
  ],
  'DFSK': ['Other', 'C31', 'Eagle 580', 'Eagle Pro', 'Glory 330', 'K01'],
  'Daewoo': [
    'Chairman',
    'Cielo',
    'Espero',
    'Juliet',
    'Lacetti',
    'Lanos',
    'Leganza',
    'Matiz',
    'Musso',
    'Nubira',
    'Prince',
    'Racer',
    'Tico',
    'Zaz',
    'Other'
  ],
  'Daihatsu': [
    'Applause',
    'Charade',
    'Charmant',
    'Feroza',
    'Gran Max',
    'Grand Terios',
    'Kancil',
    'Materia',
    'Mira',
    'Pickup',
    'Rocky',
    'Sirion',
    'Terios',
    'YRV',
    'Other'
  ],
  'Dodge': [
    'Caliber',
    'Caravan',
    'Challenger',
    'Charger',
    'Dart',
    'Durango',
    'Nitro',
    'Ram',
    'Other'
  ],
  'Faw': ['B30', 'Dream', 'N5', 'Pickup', 'Van', 'Vita', 'X40', 'Other'],
  'Ferrari': ['Ferrari'],
  'Fiat': [
    '124',
    '125',
    '126',
    '127',
    '128',
    '128 Nova',
    '1300',
    '131',
    '132',
    '500',
    '500C',
    '500X',
    'Albea',
    'Argenta',
    'Brava',
    'Bravo',
    'Croma',
    'Doblo',
    'Dogan',
    'Fiorino',
    'Florida',
    'Grand Punto',
    'Linea',
    'Marea',
    'Palio',
    'Panda',
    'Petra',
    'Polonez',
    'Punto',
    'Qubo',
    'Regata',
    'Ritmo',
    'Shahin',
    'Shinko',
    'Siena',
    'Tempra',
    'Tipo',
    'Uno',
    'Zastava',
    'Other'
  ],
  'Ford': [
    'Aerostar',
    'B-Max',
    'Bronco',
    'C-max',
    'Crown Victoria',
    'EcoSport',
    'Edge',
    'Escape',
    'Escort',
    'Excursion',
    'Expedition',
    'Explorer',
    'F 250',
    'F150',
    'Fairmont',
    'Fiesta',
    'Focus',
    'Fusion',
    'Grand C-MAX',
    'Ka',
    'Kuga',
    'mercury',
    'Mondeo',
    'Mustang',
    'Ranger',
    'Taurus',
    'Van',
    'Windstar',
    'Other'
  ],
  'GMC': [
    'Acadia',
    'Envoy',
    'Jimmy',
    'Pickup',
    'Savana',
    'Sierra',
    'Suburban',
    'Terrain',
    'Yukon',
    'Other'
  ],
  'Geely': [
    'Ck',
    'Ck2',
    'Emgrand 7',
    'Emgrand X7',
    'Englon',
    'Frota',
    'Imperial',
    'Maple',
    'MK',
    'Pandido',
    'Sparky',
    'X Pandido',
    'Other'
  ],
  'Great Wall': ['C30', 'Coolbear', 'Florid', 'Hover', 'Peri', 'Other'],
  'Haval': ['H6', 'Jolion', 'Other'],
  'Honda': [
    'Accord',
    'City',
    'Civic',
    'CR-V',
    'CR-X',
    'HR-V',
    'Integra',
    'Jazz',
    'Odyssey',
    'Pilot',
    'Prelude',
    'Other'
  ],
  'Hummer': ['H1', 'H2', 'H3', 'HX', 'Other'],
  'Hyundai': [
    'Accent',
    'Atos',
    'Avante',
    'Azera',
    'Bayon',
    'Centennial',
    'Coupe',
    'Creta',
    'Elantra',
    'Elantra Coupe',
    'Excel',
    'Galloper',
    'Genesis',
    'Getz',
    'Grand I10',
    'H1',
    'H100',
    'I10',
    'I20',
    'I30',
    'I40',
    'IX20',
    'IX35',
    'Matrix',
    'Pony',
    'Santa Fe',
    'Santamo',
    'Solaris',
    'Sonata',
    'Stellar',
    'Terracan',
    'Tiburon',
    'Trajet',
    'Tucson',
    'Veloster',
    'Verna',
    'Viva',
    'Other'
  ],
  'Infiniti': ['EX', 'FX', 'Q', 'QX', 'Other'],
  'Isuzu': ['D-Max', 'Rodeo', 'Trooper', 'Other'],
  'Jac': [
    'A10',
    'A13',
    'B15',
    'Eagle',
    'J3',
    'J5',
    'J7',
    'JS3',
    'JS4',
    'S2',
    'S3',
    'S4',
    'S7',
    'Other'
  ],
  'Jaguar': [
    'E-Pace',
    'F-Pace',
    'F-type',
    'S-Type',
    'X-Type',
    'XE',
    'XF',
    'XFR',
    'XJ',
    'XJ6',
    'XJR',
    'XK',
    'XK8',
    'XKR',
    'Other'
  ],
  'Jeep': [
    'Cherokee',
    'Commander',
    'Compass',
    'Grand Cherokee',
    'Liberty',
    'Patriot',
    'Renegade',
    'Wagoneer',
    'Wrangler',
    'Other'
  ],
  'Jetour': ['X70', 'X95', 'Other'],
  'KYC': ['X3', 'X5', 'X5 plus'],
  'Kia': [
    'Carens',
    'Carnival',
    'Ceed',
    'Cerato',
    'Cerato Coupe',
    'Clarus',
    'Mohave',
    'Oprius',
    'Optima',
    'Pegas',
    'Picanto',
    'Pride',
    'Rio',
    'Sephia',
    'Shuma',
    'Sorento',
    'Soul',
    'Spectra',
    'Sportage',
    'Xceed',
    'Other'
  ],
  'King Long': ['Van'],
  'Lada': [
    '1200',
    '124',
    '1300',
    '1500',
    '2101',
    '2102',
    '2104',
    '2105',
    '2106',
    '2107',
    '2110',
    '2111',
    '2112',
    'Alico',
    'Granta',
    'Kalina',
    'Niva',
    'Oka',
    'Samara',
    'Other'
  ],
  'Lamborghini': ['Aventador', 'Gallardo', 'Huracan', 'Other'],
  'Lancia': ['Dedra', 'Delta', 'Thema'],
  'Land Rover': [
    'Defender',
    'Discovery',
    'Discovery Sport',
    'Evoque',
    'Freelander',
    'LR2',
    'LR3',
    'LR4',
    'Range Rover',
    'Range Rover Sport',
    'Range Rover Sport SVR',
    'Range Rover Vogue',
    'Velar',
    'Other'
  ],
  'Lexus': ['GX', 'LS', 'LX', 'NX', 'RX', 'Other'],
  'Lifan': ['320', '520', '520i', '620', 'Foison', 'X60', 'Other'],
  'Lincoln': ['Navigator', 'Town Car', 'Other'],
  'Lotus': ['Exige', 'Evora', 'Other'],
  'MG': [
    '360',
    '6',
    'C 350',
    'MG 3',
    'MG 3 Cross Over',
    'MG 5',
    'MG 750',
    'RX5',
    'S350',
    'ZS',
    'HS',
    'Other'
  ],
  'MINI': [
    'Cabrio',
    'Clubman',
    'Convertible',
    'Cooper',
    'Cooper Paceman',
    'Cooper Roadster',
    'Cooper s',
    'Countryman',
    'Countryman S',
    'Coupe',
    'John Cooper Works',
    'Other'
  ],
  'Maserati': [
    'Ghibli',
    'GranCabrio',
    'GranTurismo',
    'QP',
    'Quattroporte',
    'Other'
  ],
  'Mazda': [
    '121',
    '2',
    '3',
    '323',
    '6',
    '626',
    '929',
    'CX',
    'Familia',
    'MX',
    'Pickup',
    'RX',
    'Other'
  ],
  'McLaren': ['570S', '650S', '720S', 'MP4-12C', 'Other'],
  'Mercedes-Benz': [
    '190',
    '200',
    '230',
    'A150',
    'A180',
    'A200',
    'B150',
    'B200',
    'C180',
    'C200',
    'C230',
    'C240',
    'C250',
    'C280',
    'C300',
    'C350',
    'C63',
    'CL-Class',
    'CLA 180',
    'CLA 200',
    'CLC-Class',
    'CLK-Class',
    'CLS',
    'E180',
    'E200',
    'E220',
    'E230',
    'E240',
    'E250',
    'E280',
    'E300',
    'E320',
    'E350',
    'E400',
    'E63',
    'G-Class',
    'GL-Class',
    'GLA 200',
    'GLC 250',
    'GLC 300',
    'GLE-Class',
    'GLK 250',
    'GLK 300',
    'GLK 350',
    'M-Class',
    'Maybach',
    'R-Class',
    'S280',
    'S300',
    'S320',
    'S350',
    'S400',
    'S450',
    'S500',
    'SEL 200',
    'SEL 260',
    'SEL 280',
    'SEL 300',
    'SEL 500',
    'SL-Class',
    'SLC-Class',
    'SLK-Class',
    'Viano',
    'Other'
  ],
  'Mitsubishi': [
    'Atrage',
    'Colt',
    'Eclipse',
    'Evolution',
    'Galant',
    'Grandis',
    'Lancer',
    'Mirage',
    'Montero',
    'Nativa',
    'Outlander',
    'Pajero',
    'Pickup',
    'Van',
    'Xpander',
    'Other'
  ],
  'Nissan': [
    'Altima',
    'Armada',
    'Bluebird',
    'Datsun',
    'Gloria',
    'GT-R',
    'Juke',
    'Livina',
    'March',
    'Maxima',
    'Murano',
    'Pathfinder',
    'Patrol',
    'Pickup',
    'Qashqai',
    'Sentra',
    'Sunny',
    'Tiida',
    'Titan',
    'Van',
    'X-Trail',
    'ZX',
    'Other',
    'Z'
  ],
  'Opel': [
    'Adam',
    'Astra',
    'Cascada',
    'Corsa',
    'Crossland',
    'Grandland',
    'Insignia',
    'Kadett',
    'Meriva',
    'Mokka',
    'Omega',
    'Rekord',
    'Tigra',
    'Vectra',
    'Other'
  ],
  'Other make': [
    'DFM',
    'Foton',
    'Hafei',
    'Haima',
    'Hawtai',
    'Jonway',
    'Karry',
    'Kenbo',
    'Keyton',
    'Landwind',
    'Mahindra',
    'Pontiac',
    'Smart',
    'Tata',
    'Other'
  ],
  'Peugeot': [
    '1007',
    '104',
    '106',
    '2008',
    '204',
    '205',
    '206',
    '207',
    '207 SW',
    '208',
    '3008',
    '301',
    '304',
    '305',
    '306',
    '307',
    '307 SW',
    '308',
    '308 SW',
    '309',
    '403',
    '404',
    '405',
    '406',
    '407',
    '408',
    '5008',
    '504',
    '504 SW',
    '505',
    '508',
    '605',
    '607',
    'Pars',
    'Partner',
    'RC7',
    'RCZ',
    'Other'
  ],
  'Porsche': [
    '911',
    '944',
    '968',
    'Boxster',
    'Carrera',
    'Cayenne',
    'Cayman',
    'Macan',
    'Panamera',
    'Other'
  ],
  'Proton': [
    'Exora',
    'Gen-2',
    'Persona',
    'Preve',
    'Saga',
    'Waja',
    'Wira',
    'Other'
  ],
  'Renault': [
    '11',
    '12',
    '14',
    '18',
    '19',
    '21',
    '25',
    '5',
    '9',
    'Captur',
    'Clio',
    'Dacia',
    'Duster',
    'Fluence',
    'Kadjar',
    'Kangoo',
    'Laguna',
    'Lodgy',
    'Logan',
    'Logan MCV',
    'Megane',
    'Optima',
    'Rainbow',
    'Safrane',
    'Sandero',
    'Sandero Stepway',
    'Scala',
    'Scenic',
    'Symbol',
    'Other'
  ],
  'Rolls Royce': ['Cullinan', 'Dawn', 'Ghost', 'Phantom', 'Wraith', 'Other'],
  'Saipa': ['Pride', 'Pride Sedan', 'Tiba', 'Other'],
  'Seat': [
    '124',
    '132',
    '133',
    'Altea',
    'Arona',
    'Ateca',
    'Cordoba',
    'Ibiza',
    'Leon',
    'Marbella',
    'Toledo',
    'Tarraco',
    'Other'
  ],
  'Senova': ['A1', 'A3', 'X25', 'X35', 'Other'],
  'Skoda': [
    'Fabia',
    'Favorit',
    'Felecia',
    'Felicia Combi',
    'Forman',
    'GLS-120',
    'Kamiq',
    'Karoq',
    'Kodiaq',
    'Octavia',
    'Pick up',
    'Rapid',
    'Roomster',
    'Scala',
    'Superb',
    'Yeti',
    'Other'
  ],
  'Soueast': ['A5', 'DX3', 'DX5', 'DX7', 'Other'],
  'Speranza': [
    'A11',
    'A113',
    'A213',
    'A516',
    'A620',
    'Envy',
    'M11',
    'M12',
    'Tiggo'
  ],
  'Ssang Yong': ['Korando', 'Musso', 'Tivoli', 'Tivoli XLV', 'Other'],
  'Subaru': ['Forester', 'Impreza', 'Legacy', 'Outback', 'WRX', 'XV', 'Other'],
  'Suzuki': [
    'Alto',
    'APV',
    'Baleno',
    'Celerio',
    'Ciaz',
    'Dzire',
    'Ertiga',
    'Grand Vitara',
    'Jimny',
    'Maruti',
    'Pick up',
    'S-Presso',
    'Swift',
    'SX4',
    'Van',
    'Vitara',
    'XL7',
    'Other'
  ],
  'Tesla': ['Model 3', 'Model S', 'Model X', 'Other'],
  'Toyota': [
    '4Runner',
    'Auris',
    'Avalon',
    'Avanza',
    'Avensis',
    'Belta',
    'C-HR',
    'Camry',
    'Celica',
    'Corolla',
    'Corona',
    'Cressida',
    'Crown',
    'Echo',
    'FJ Cruiser',
    'Fortuner',
    'Hiace',
    'Hilux',
    'Innova',
    'IQ',
    'Land Cruiser',
    'Prado',
    'Previa',
    'Prius',
    'Rav 4',
    'Rumion',
    'Rush',
    'Scion',
    'Starlet',
    'Supra',
    'Tacoma',
    'Tercel',
    'XA',
    'Yaris',
    'Other'
  ],
  'Volkswagen': [
    'Amarok',
    'Beetle',
    'Bora',
    'Caddy',
    'Caravelle',
    'CC',
    'CrossFox',
    'Eos',
    'Golf',
    'Jetta',
    'Parati',
    'Passat',
    'Phaeton',
    'Pointer',
    'Polo',
    'Scirocco',
    'Souran',
    'Tiguan',
    'Touareg',
    'Transporter',
    'Vento',
    'Other'
  ],
  'Volvo': [
    '144',
    '240',
    '244',
    '340',
    '460',
    '740',
    '760',
    '850',
    '940',
    'c30',
    's40',
    's60',
    'S70',
    's80',
    'S90',
    'V40',
    'V50',
    'V70',
    'XC60',
    'XC70',
    'XC90',
    'XC40',
    'Other'
  ],
  'Zotye': ['Explosion', 'SR7', 'T600', 'Other']
};