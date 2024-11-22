import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}
// Modelo de dados para armazenar informações de um país
class Country {
  final String name;
  final String officialName;
  final String code;
  final String capital;
  final String currency;
  final String dialCode;
  final String language;
  final String region;
  final String subregion;
  final String area;
  final List<String> borders;

  Country({
    required this.name,
    required this.officialName,
    required this.code,
    required this.capital,
    required this.currency,
    required this.dialCode,
    required this.language,
    required this.region,
    required this.subregion,
    required this.area,
    required this.borders,
  });
// Construtor de fábrica que cria um objeto Country a partir de um JSON
  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: translateCountry(json['name']['common'] ?? 'N/A'),
      officialName: json['name']['official'] ?? 'N/A',
      code: json['cca3'] ?? 'N/A',
      capital: (json['capital'] != null && json['capital'].isNotEmpty)
          ? json['capital'][0]
          : 'N/A',
      currency: json['currencies']?.keys.first ?? 'N/A',
      dialCode: json['idd']['root'] != null && json['idd']['suffixes'] != null
          ? json['idd']['root'] + json['idd']['suffixes'][0]
          : 'N/A',
      language: json['languages']?.values.first ?? 'N/A',
      region: json['region'] ?? 'N/A',
      subregion: json['subregion'] ?? 'N/A',
      area: json['area']?.toString() ?? 'N/A',
      borders: (json['borders'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}

// traduções dos países
final Map<String, String> countryTranslations = {
  'Afghanistan': 'Afeganistão',
  'Albania': 'Albânia',
  'Algeria': 'Argélia',
  'Andorra': 'Andorra',
  'Angola': 'Angola',
  'Argentina': 'Argentina',
  'Armenia': 'Armênia',
  'Australia': 'Austrália',
  'Austria': 'Áustria',
  'Azerbaijan': 'Azerbaijão',
  'Bahamas': 'Bahamas',
  'Bahrain': 'Bahrein',
  'Bangladesh': 'Bangladesh',
  'Barbados': 'Barbados',
  'Belarus': 'Bielorrússia',
  'Belgium': 'Bélgica',
  'Belize': 'Belize',
  'Benin': 'Benin',
  'Bhutan': 'Butão',
  'Bolivia': 'Bolívia',
  'Bosnia and Herzegovina': 'Bósnia e Herzegovina',
  'Botswana': 'Botsuana',
  'Brazil': 'Brasil',
  'Bulgaria': 'Bulgária',
  'Burundi': 'Burundi',
  'Cambodia': 'Camboja',
  'Cameroon': 'Camarões',
  'Canada': 'Canadá',
  'Chile': 'Chile',
  'China': 'China',
  'Colombia': 'Colômbia',
  'Comoros': 'Comores',
  'Congo': 'Congo',
  'Croatia': 'Croácia',
  'Cuba': 'Cuba',
  'Cyprus': 'Chipre',
  'Czech Republic': 'República Tcheca',
  'Denmark': 'Dinamarca',
  'Djibouti': 'Djibouti',
  'Dominica': 'Dominica',
  'Dominican Republic': 'República Dominicana',
  'Ecuador': 'Equador',
  'Egypt': 'Egito',
  'El Salvador': 'El Salvador',
  'Estonia': 'Estônia',
  'Ethiopia': 'Etiópia',
  'Fiji': 'Fiji',
  'Finland': 'Finlândia',
  'France': 'França',
  'Gabon': 'Gabão',
  'Gambia': 'Gâmbia',
  'Georgia': 'Geórgia',
  'Germany': 'Alemanha',
  'Ghana': 'Gana',
  'Greece': 'Grécia',
  'Grenada': 'Granada',
  'Guatemala': 'Guatemala',
  'Guinea': 'Guiné',
  'Guyana': 'Guiana',
  'Haiti': 'Haiti',
  'Honduras': 'Honduras',
  'Hungary': 'Hungria',
  'Iceland': 'Islândia',
  'India': 'Índia',
  'Indonesia': 'Indonésia',
  'Iran': 'Irã',
  'Iraq': 'Iraque',
  'Ireland': 'Irlanda',
  'Israel': 'Israel',
  'Italy': 'Itália',
  'Jamaica': 'Jamaica',
  'Japan': 'Japão',
  'Jordan': 'Jordânia',
  'Kazakhstan': 'Cazaquistão',
  'Kenya': 'Quênia',
  'Kiribati': 'Kiribati',
  'Kuwait': 'Kuwait',
  'Kyrgyzstan': 'Quirguistão',
  'Laos': 'Laos',
  'Latvia': 'Letônia',
  'Lebanon': 'Líbano',
  'Lesotho': 'Lesoto',
  'Liberia': 'Libéria',
  'Libya': 'Líbia',
  'Liechtenstein': 'Liechtenstein',
  'Lithuania': 'Lituânia',
  'Luxembourg': 'Luxemburgo',
  'Madagascar': 'Madagascar',
  'Malawi': 'Malawi',
  'Malaysia': 'Malásia',
  'Maldives': 'Maldivas',
  'Mali': 'Mali',
  'Malta': 'Malta',
  'Mexico': 'México',
  'Moldova': 'Moldávia',
  'Monaco': 'Mônaco',
  'Mongolia': 'Mongólia',
  'Morocco': 'Marrocos',
  'Mozambique': 'Moçambique',
  'Myanmar': 'Mianmar',
  'Namibia': 'Namíbia',
  'Nauru': 'Nauru',
  'Nepal': 'Nepal',
  'Netherlands': 'Países Baixos',
  'New Zealand': 'Nova Zelândia',
  'Nicaragua': 'Nicarágua',
  'Niger': 'Níger',
  'Nigeria': 'Nigéria',
  'Norway': 'Noruega',
  'Oman': 'Omã',
  'Pakistan': 'Paquistão',
  'Palau': 'Palau',
  'Panama': 'Panamá',
  'Paraguay': 'Paraguai',
  'Peru': 'Peru',
  'Philippines': 'Filipinas',
  'Poland': 'Polônia',
  'Portugal': 'Portugal',
  'Qatar': 'Catar',
  'Romania': 'Romênia',
  'Russia': 'Rússia',
  'Rwanda': 'Ruanda',
  'Samoa': 'Samoa',
  'Saudi Arabia': 'Arábia Saudita',
  'Senegal': 'Senegal',
  'Serbia': 'Sérvia',
  'Singapore': 'Singapura',
  'Slovakia': 'Eslováquia',
  'Slovenia': 'Eslovênia',
  'Somalia': 'Somália',
  'South Africa': 'África do Sul',
  'South Korea': 'Coreia do Sul',
  'Spain': 'Espanha',
  'Sri Lanka': 'Sri Lanka',
  'Sudan': 'Sudão',
  'Sweden': 'Suécia',
  'Switzerland': 'Suíça',
  'Syria': 'Síria',
  'Thailand': 'Tailândia',
  'Togo': 'Togo',
  'Tonga': 'Tonga',
  'Tunisia': 'Tunísia',
  'Turkey': 'Turquia',
  'Uganda': 'Uganda',
  'Ukraine': 'Ucrânia',
  'United Kingdom': 'Reino Unido',
  'United States': 'Estados Unidos',
  'Uruguay': 'Uruguai',
  'Uzbekistan': 'Uzbequistão',
  'Vanuatu': 'Vanuatu',
  'Vatican City': 'Vaticano',
  'Venezuela': 'Venezuela',
  'Vietnam': 'Vietnã',
  'Yemen': 'Iêmen',
  'Zambia': 'Zâmbia',
  'Zimbabwe': 'Zimbábue',
};

// Função para traduzir o nome do país
String translateCountry(String country) {
  return countryTranslations[country] ?? country;
}
// Widget principal do aplicativo
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CountryListScreen(),
    );
  }
}
// Tela que lista os países
class CountryListScreen extends StatefulWidget {
  const CountryListScreen({super.key});

  @override
  _CountryListScreenState createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  late Future<List<Country>> countries;
  List<Country> allCountries = [];
  List<Country> filteredCountries = [];

  @override
  void initState() {
    super.initState();
    countries = fetchCountries();
  }
// Função para buscar os países na API
  Future<List<Country>> fetchCountries() async {
    final response =
    await http.get(Uri.parse('https://restcountries.com/v3.1/all'));

    if (response.statusCode == 200) {
      final List<dynamic> countryList = jsonDecode(response.body);
      final List<Country> countries =
      countryList.map((json) => Country.fromJson(json)).toList();

      // Ordenar a lista de países em ordem alfabética pelo nome
      countries.sort((a, b) => a.name.compareTo(b.name));

      setState(() {
        allCountries = countries;
        filteredCountries = countries;
      });
      return countries;
    } else {
      throw Exception('Falha ao carregar dados');
    }
  }
// Função chamada quando há alteração na busca
  void updateSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCountries = allCountries;
      } else {
        filteredCountries = allCountries
            .where((country) =>
            country.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      // Ordena a lista filtrada
      filteredCountries.sort((a, b) => a.name.compareTo(b.name));
    });
  }
// Função para navegar até a tela de detalhes do país
  void _navigateToDetails(Country country) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountryDetailScreen(country: country),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.blue[900],
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 80,
                ),
                Spacer(),
                SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    // Redireciona para o Sobre
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondPage()),
                    );
                  },
                  child: Text(
                    'Sobre',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pesquise por um país',
                  style: TextStyle(fontSize: 26, color: Colors.black),
                ),
                SizedBox(height: 8),
                TextField(
                  onChanged: updateSearch,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Country>>(
              future: countries,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar dados'));
                } else {
                  return ListView.builder(
                    itemCount: filteredCountries.length,
                    itemBuilder: (context, index) {
                      final country = filteredCountries[index];
                      return GestureDetector(
                        onTap: () => _navigateToDetails(country),
                        child: Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 8),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black, width: 1.0),
                            borderRadius: BorderRadius.circular(0.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      country.name,
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    Text(
                                      '>',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ],
                                ),
                                Divider(),
                                buildInfoRow('CAPITAL', country.capital),
                                buildInfoRow('MOEDA', country.currency),
                                buildInfoRow('CÓDIGO DE DISCAGEM INTERNACIONAL',
                                    country.dialCode),
                                buildInfoRow('LÍNGUA', country.language),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
// Função para criar um componente de linha de informação
  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
// Tela de detalhes de um país
class CountryDetailScreen extends StatelessWidget {
  final Country country;

  const CountryDetailScreen({Key? key, required this.country})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.blue[900],
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 50,
                ),
                Spacer(),
                SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    // Redireciona para o Sobre
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondPage()),
                    );
                  },
                  child: Text(
                    'Sobre',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
      
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Procurar / ',
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  country.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              height: 40.0,
              color: Colors.white,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  country.name.toUpperCase(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            sectionTitle('NOMES'),
            buildDetailRow('COMUM', country.name),
            buildDetailRow('OFICIAL', country.officialName),
            buildDetailRow('SIGLA', country.code),
            buildDetailRow('LÍNGUA', country.language),
            SizedBox(height: 0),
            sectionTitle('GEOGRAFIA'),
            buildDetailRow('REGIÃO', country.region),
            buildDetailRow('SUB-REGIÃO', country.subregion),
            buildDetailRow('CAPITAL', country.capital),
            buildDetailRow(
              'FRONTEIRAS',
              country.borders.isNotEmpty
                  ? country.borders.join(', ')
                  : 'Nenhuma',
            ),
            buildDetailRow('ÁREA', '${country.area} km²'),
            sectionTitle('CÓDIGOS'),
            buildDetailRow(
                'CÓDIGO DE DISCAGEM INTERNACIONAL', country.dialCode),
            buildDetailRow('CÓDIGO DE MOEDA', country.currency),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
    );
  }
// Função para criar uma linha de detalhe 
  Widget buildDetailRow(String label, String value, {Color? backgroundColor}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[200],
        borderRadius: BorderRadius.circular(0),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
// Tela explicativa sobre o aplicativo
class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.blue[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.blue[900],
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 50,
                ),
                Spacer(),
                SizedBox(width: 10),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(

          child: Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: Text('  SOBRE',
                      style: TextStyle(
                        fontSize: 26,
                      )
                      ),
                  width: double.infinity,
                  height: 40.0,
                  color: Colors.white,
                ),
                Text(
                  'Este aplicativo foi criado para ser uma maneira simples e'
                    ' fácil de explorar e pesquisar informações sobre países do mundo. '
                    'Ele pode oferecer uma vasta gama de informações, desde dados geográficos, '
                    'como a localização e, até aspectos culturais, como tradições, e idiomas,'
                    ' podendo ajudar os usuários a entender melhor o contexto de cada nação.',
                  style: TextStyle(color: Colors.black, fontSize: 24),

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}