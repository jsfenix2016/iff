class Constant {
  static const baseApi = '';
  static const baseApiMessageBird = 'https://rest.messagebird.com/';
  static const personalInformation = 'Datos personales';
  static const selectGender = 'Selecciona el genero';
  static const selectCity = 'Selecciona la ciudad';
  static const maritalStatus = 'Estado civil';
  static const styleLive = 'Estilo de vida';
  static const telephone = 'Telefono';
  static const telephonePlaceholder = 'Ingresa un telefono';
  static const nameUser = 'Nombre';
  static const namePlaceholder = 'Ingresa un nombre';
  static const lastName = 'Apellido';
  static const email = 'Correo electronico';
  static const lastnamePlaceholder = 'Ingresa un apellido';
  static const codeEmail = 'Codigo de correo';
  static const codeEmailPlaceholder = 'Ingresa un codigo correo';
  static const codeSms = 'Codigo de sms';
  static const codeSmsPlaceholder = 'Ingresa un codigo sms';
  static const continueTxt = 'Continuar';
  static const saveBtn = 'Guardar';
  static const nextTxt = 'Siguiente';
  static const age = 'Edad';
  static const onBoardingWelcome = 'Bienvenida/o a I’m fine';
  static const onBoardingWelcomeMessage =
      'Si vives feliz solo o sola además, quieres sentirte protegido/a';

  static const onBoardingPageTwoTitle = 'Ante una situación de riesgo';
  static const onBoardingPageTwoSubtitle =
      'Si IFeelFine no detecta actividad o movimiento en tu smartphone';

  static const onBoardingPageTreeTitle = 'Avisa a las personas que elijas';
  static const onBoardingPageTreeSubtitle =
      'Con IFeelFine, aunque vivas solo o sola, te sentiras protegido/a';

  static const onBoardingPageFourTitle = 'Ahora ya puedes descansar';
  static const onBoardingPageFourSubtitle =
      'Si vives feliz solo o sola pero ademas quieres sentirte protegido/a mientras estas en casa o de viaje';

  static const alternativePageButtonPersonalizar = 'Personalizar ajustes';
  static const alternativePageButtonInit = 'Comenzar a usar';

  static const userConfigPageButtonFree = 'Gratuito 30 dias';
  static const userConfigPageButtonProtection = 'Protección 360';
  static const userConfigPageButtonConfig = 'Configurar';

  static const hoursRest = 'A que horas duermes';
  static const hoursSleepAndWakeup = '¿A qué hora te acuestas y te levantas?';
  static const casefallText = '¿Deseas que, en caso de alerta, enviemos tu ubicación a tus contactos?';

  static const permissionApp = 'Permisos que se usan en la app';

  static const Map<String, String> gender = {
    '0': 'Hombre',
    '1': 'Mujer',
    '2': 'Otro/a',
  };

  static const Map<String, String> maritalState = {
    '0': 'Soltero',
    '1': 'Casado',
    '2': 'Divorsiado',
  };

  static const Map<String, String> lifeStyle = {
    '0': 'Sedentario',
    '1': 'Aventurero',
    '2': 'Etc',
  };

  static const Map<String, String> timeDic = {
    "0": '5 min',
    "1": '10 min',
    "2": '20 min',
    "3": '30 min',
    "4": '40 min',
    "5": '50 min',
    "6": '2 hora',
    "7": '3 hora',
    "8": '4 hora',
    "9": '5 hora',
    "10": '6 hora',
    "11": '7 hora',
    "12": '8 hora',
    "13": '9 hora',
    "14": '10 hora',
    "15": '11 hora',
    "16": '12 hora',
  };

  static const Map<String, String> timeDicExtended = {
    "0": '2 min',
    "1": '5 min',
    "2": '10 min',
    "3": '15 min',
    "4": '20 min',
    "5": '30 min',
    "6": '40 min',
    "7": '50 min',
    "8": '2 horas',
    "9": '3 horas',
    "10": '4 horas',
    "11": '5 horas',
    "12": '6 horas',
    "13": '7 horas',
    "14": '8 horas',
    "15": '9 horas',
    "16": '10 horas',
    "17": '11 horas',
    "18": '12 horas',
  };

  static const Map<String, String> hours = {
    "0": '00',
    "1": '01',
    "2": '02',
    "3": '03',
    "4": '04',
    "5": '05',
    "6": '06',
    "7": '07',
    "8": '08',
    "9": '09',
    "10": '10',
    "11": '11',
    "12": '12',
    "13": '13',
    "14": '14',
    "15": '15',
    "16": '16',
    "17": '17',
    "18": '18',
    "19": '19',
    "20": '20',
    "21": '21',
    "22": '22',
    "23": '23',
  };

  static const Map<String, String> minutes = {
    "0": '00',
    "1": '15',
    "2": '30',
    "3": '45'
  };

  static const Map<String, String> weekend = {
    '0': 'Lunes',
    '1': 'Martes',
    '2': 'Miercoles',
    '3': 'Jueves',
    '4': 'Viernes',
    '5': 'Sabado',
    '6': 'Domingo'
  };

  static const List<String> tempListDay = <String>[
    "Lunes",
    "Martes",
    "Miercoles",
    "Jueves",
    "Viernes",
    "Sabado",
    "Domingo",
  ];

  static const Map<String, String> timeDicAge = {
    "0": '18',
    "1": '19',
    "2": '20',
    "3": '21',
    "4": '22',
    "5": '23',
    "6": '24',
    "7": '25',
    "8": '4 hora',
    "9": '5 hora',
    "10": '6 hora',
    "11": '7 hora',
    "12": '8 hora',
    "13": '9 hora',
    "14": '10 hora',
    "15": '11 hora',
    "16": '12 hora',
  };

  static const String disablePermission = "Para poder desactivar el permiso, se ha de hacer desde los Ajustes de la app";
  static const String enablePermission = "Para poder activar el permiso, se ha de hacer desde los Ajustes de la app";
}
