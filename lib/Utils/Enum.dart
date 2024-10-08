List Province() {
  return [
    'Koshi',
    'Madhesh',
    'Bagmati',
    'Gandaki',
    'Lumbini',
    'Karnali',
    'Sudurpaschim'
  ];
}

List getDistrictsByProvince(String province) {
  switch (province) {
    case "Koshi":
      return [
        'Ilam',
        'Udayapur',
        'Okhaldhunga',
        'Khotang',
        'Jhapa',
        'Taplejung',
        'Tehrathum',
        'Dhankuta',
        'Panchthar',
        'Bhojpur',
        'Morang',
        'Sankhuwasabha',
        'Sunsari',
        'Solukhumbu'
      ];

    case "Madhesh":
      return [
        'Dhanusha',
        'Parsa',
        'Bara',
        'Mahottari',
        'Rautahat',
        'Saptari',
        'Sarlahi',
        'Siraha'
      ];

    case "Bagmati":
      return [
        'Kathmandu',
        'Kavrepalanchok',
        'Chitwan',
        'Dolakha',
        'Dhading',
        'Nuwakot',
        'Bhaktapur',
        'Makwanpur',
        'Rasuwa',
        'Ramechhap',
        'Lalitpur',
        'Sindhupalchok',
        'Sindhuli'
      ];

    case "Gandaki":
      return [
        'Kaski',
        'Gorkha',
        'Tanahun',
        'Nawalparasi (Bardaghat Susta East)',
        'Parbat',
        'Baglung',
        'Manang',
        'Mustang',
        'Myagdi',
        'Lamjung',
        'Syangja'
      ];

    case "Lumbini":
      return [
        'Arghakhanchi',
        'Kapilvastu',
        'Gulmi',
        'Dang',
        'Nawalparasi (Bardaghat Susta West)',
        'Palpa',
        'Purbi',
        'Pyuthan',
        'Bardiya',
        'Banke',
        'Rupandehi',
        'Rolpa'
      ];

    case "Karnali":
      return [
        'Kalikot',
        'Jajarkot',
        'Jumla',
        'Dolpa',
        'Dailekh',
        'Paschim Rukum',
        'Mugu',
        'Salyan',
        'Surkhet',
        'Humla',
      ];

    case "Sudurpaschim":
      return [
        'Achham',
        'Kanchanpur',
        'Kailali',
        'Dadeldhura',
        'Doti',
        'Darchula',
        'Bajhang',
        'Bajura',
        'Baitadi',
      ];
    default:
      return [
        'Ilam',
        'Udayapur',
        'Okhaldhunga',
        'Khotang',
        'Jhapa',
        'Taplejung',
        'Tehrathum',
        'Dhankuta',
        'Panchthar',
        'Bhojpur',
        'Morang',
        'Sankhuwasabha',
        'Sunsari',
        'Solukhumbu',
        'Dhanusha',
        'Parsa',
        'Bara',
        'Mahottari',
        'Rautahat',
        'Saptari',
        'Sarlahi',
        'Siraha',
        'Kathmandu',
        'Kavrepalanchok',
        'Chitwan',
        'Dolakha',
        'Dhading',
        'Nuwakot',
        'Bhaktapur',
        'Makwanpur',
        'Rasuwa',
        'Ramechhap',
        'Lalitpur',
        'Sindhupalchok',
        'Sindhuli',
        'Kaski',
        'Gorkha',
        'Tanahun',
        'Nawalparasi (Bardaghat Susta East)',
        'Parbat',
        'Baglung',
        'Manang',
        'Mustang',
        'Myagdi',
        'Lamjung',
        'Syangja',
        'Arghakhanchi',
        'Kapilvastu',
        'Gulmi',
        'Dang',
        'Nawalparasi (Bardaghat Susta West)',
        'Palpa',
        'Purbi',
        'Pyuthan',
        'Bardiya',
        'Banke',
        'Rupandehi',
        'Rolpa',
        'Kalikot',
        'Jajarkot',
        'Jumla',
        'Dolpa',
        'Dailekh',
        'Paschim Rukum',
        'Mugu',
        'Salyan',
        'Surkhet',
        'Humla',
        'Achham',
        'Kanchanpur',
        'Kailali',
        'Dadeldhura',
        'Doti',
        'Darchula',
        'Bajhang',
        'Bajura',
        'Baitadi',
      ];
  }
}

// List emergencyContactFilter(){
//   return [
//     'All',
//     'Organization',
//     'Police',
//     'Hospital',
//   ];
// }
