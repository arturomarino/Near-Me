import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it')
  ];

  /// No description provided for @language.
  ///
  /// In it, this message translates to:
  /// **'Italiano'**
  String get language;

  /// No description provided for @wifi.
  ///
  /// In it, this message translates to:
  /// **'Imposta WiFi'**
  String get wifi;

  /// No description provided for @impostazioni.
  ///
  /// In it, this message translates to:
  /// **'Impostazioni'**
  String get impostazioni;

  /// No description provided for @copia.
  ///
  /// In it, this message translates to:
  /// **'Copia'**
  String get copia;

  /// No description provided for @apri_imposta.
  ///
  /// In it, this message translates to:
  /// **'Apri Impostazioni'**
  String get apri_imposta;

  /// No description provided for @istruzioni.
  ///
  /// In it, this message translates to:
  /// **'-Copia la Password\n-Apri Impostazioni WiFi\n-Scegli \'iChiani\'\n-Incolla la Password\n-Connetti'**
  String get istruzioni;

  /// No description provided for @lingua.
  ///
  /// In it, this message translates to:
  /// **'Lingua'**
  String get lingua;

  /// No description provided for @termini.
  ///
  /// In it, this message translates to:
  /// **'Politica sulla Riservatezza'**
  String get termini;

  /// No description provided for @esci.
  ///
  /// In it, this message translates to:
  /// **'Esci'**
  String get esci;

  /// No description provided for @cid.
  ///
  /// In it, this message translates to:
  /// **'Codice Identificativo Struttura'**
  String get cid;

  /// No description provided for @copiato.
  ///
  /// In it, this message translates to:
  /// **'Copiato negli appunti'**
  String get copiato;

  /// No description provided for @aiutoQuest.
  ///
  /// In it, this message translates to:
  /// **'Hai bisogno di aiuto?'**
  String get aiutoQuest;

  /// No description provided for @storia.
  ///
  /// In it, this message translates to:
  /// **'La Storia'**
  String get storia;

  /// No description provided for @storia_desc.
  ///
  /// In it, this message translates to:
  /// **'Perchè iChiani?'**
  String get storia_desc;

  /// No description provided for @villa.
  ///
  /// In it, this message translates to:
  /// **'La Villa'**
  String get villa;

  /// No description provided for @villa_desc.
  ///
  /// In it, this message translates to:
  /// **'Qual è il concetto iChiani?'**
  String get villa_desc;

  /// No description provided for @premi.
  ///
  /// In it, this message translates to:
  /// **'I Premi'**
  String get premi;

  /// No description provided for @premi_desc.
  ///
  /// In it, this message translates to:
  /// **'Quali sono i nostri riconoscimenti?'**
  String get premi_desc;

  /// No description provided for @alimentari.
  ///
  /// In it, this message translates to:
  /// **'Alimentari'**
  String get alimentari;

  /// No description provided for @ristoranti.
  ///
  /// In it, this message translates to:
  /// **'Ristoranti'**
  String get ristoranti;

  /// No description provided for @shopping.
  ///
  /// In it, this message translates to:
  /// **'Shopping'**
  String get shopping;

  /// No description provided for @mobilita.
  ///
  /// In it, this message translates to:
  /// **'Mobilità'**
  String get mobilita;

  /// No description provided for @salute.
  ///
  /// In it, this message translates to:
  /// **'Salute'**
  String get salute;

  /// No description provided for @rental.
  ///
  /// In it, this message translates to:
  /// **'Rental'**
  String get rental;

  /// No description provided for @attivita.
  ///
  /// In it, this message translates to:
  /// **'Attività'**
  String get attivita;

  /// No description provided for @social.
  ///
  /// In it, this message translates to:
  /// **'I Nostri Social'**
  String get social;

  /// No description provided for @dove_andare.
  ///
  /// In it, this message translates to:
  /// **'Dove andare'**
  String get dove_andare;

  /// No description provided for @ristoranti_e_pizzerie.
  ///
  /// In it, this message translates to:
  /// **'Ristoranti e Pizzerie'**
  String get ristoranti_e_pizzerie;

  /// No description provided for @dove_rifornirsi.
  ///
  /// In it, this message translates to:
  /// **'Dove Rifornirsi'**
  String get dove_rifornirsi;

  /// No description provided for @vai_button.
  ///
  /// In it, this message translates to:
  /// **'VAI'**
  String get vai_button;

  /// No description provided for @la_storia_text.
  ///
  /// In it, this message translates to:
  /// **'“Li Chiani” nel dialetto locale sta a significare terreno pianeggiante e caratterizzato prevalentemente da roccia affiorante. In questa località, nel passato, i contadini bonificarono i terreni spietrandoli per renderli fertili e adatti alla piantumazione delle tipiche colture autoctone (fichi e fichi d’india, vitigni e uliveti, capperi, etc.). Con la pietra ricavata dallo spietramento si realizzarono le architetture tipiche del Basso Salento (pajare, lamioni, murature in pietrame a secco, etc.). Villa LiChiani nasce nei primi anni ottanta e viene utilizzata prevalentemente nel periodo estivo al fine di consentire alla proprietà di godere di un periodo di meritato riposo. Nel 2017, in concomitanza dell’anno dedicato al turismo sostenibile, Villa Li Chiani subisce un profondo e sostanziale intervento di restyling che conferisce all’abitazione un design moderno e al tempo stesso compatibile con la tradizione locale e mediterranea. Nasce così  iChiani – Charming & Sustainable Holidays Il vero punto di forza di iChiani – Charmig & Sustainable Holidays è la rigenerazione dal punto di vista energetico e della sostenibilità ambientale che lo rende del tutto indipendente dalle fonti di energia fossile. La certificazione CasaClima (prot. Nr. 2017/01278) ne attesta la qualità energetica e di comfort realizzata. iChiani – Charming & Sustainable Holidayssi trova sulla Via Leucadensis che è l’antica “Via del perdono”. Su questa strada, fin dal Medioevo, i pellegrini provenienti da ogni dove percorrono la penisola salentina giungendo fino al Santuario di Santa Maria di Leuca “De Finibus Terrae”.'**
  String get la_storia_text;

  /// No description provided for @la_villa_text.
  ///
  /// In it, this message translates to:
  /// **'«Fascino & Vacanza Sostenibile»\n è il nostro motto… Ciò è stato possibile attraverso la reinterpretazione, in chiave contemporanea, della tradizione rurale pugliese e salentina. iChiani è una villa di design con piscina a Gagliano del Capo che esprime il desiderio di riscoprire la fisicità dei materiali tradizionali. Data la presenza di 4 camere servite da 3 bagni, iChiani offre 8 posti letto (+2 opzionali). Location sublime per una fuga romantica tra i dolci uliveti delle Serre del Salento, iChiani è nata per sedurre gli ospiti più esigenti in termini di comfort, sostenibilità e privacy. Una villa che ridimensiona il concetto di pieni e vuoti, la parola d’ordine è: spazio. L’ubicazione consente di spostarsi facilmente verso le località più belle della penisola salentina e verso le numerose spiagge che vanno dalla costa Adriatica a quella Ionica. Ad allietare il vostro soggiorno, la moderna piscina con vista panoramica sull’uliveto. Espressione semplice di un’architettura imponente e leggera, si mostra fiera e rispettosa della natura circostante. Anche l’atmosfera notturna è di quelle mozzafiato. Gli interni sono personalizzati attraverso elementi d’arredo minimal-chic che ne delineano lo stile. I materiali utilizzati esaltano i colori tenui della pietra salentina ed il bianco degli ambienti dona luminosità e freschezza. L’abitazione principale, ubicata in posizione dominante sull’uliveto, è dotata di una confortevole area living, quattro camere da letto (tre con letti matrimoniali e una con letti singoli uniti o divisibili), ciascuna con il proprio bagno/doccia, e un wc di servizio. Le terrazze, i loggiati e gli arredi esterni rappresentano la sintesi perfetta tra lusso e tradizione. Esternamente è possibile fruire anche di un ulteriore bagno/doccia privato per un ottimo dopo piscina. La privacy è ulteriormente garantita da un impianto di allarme collegato alle forze dell’ordine.Il nostro team offre agli ospiti di iChiani, su richiesta, un’ampia scelta di servizi esclusivi in villa'**
  String get la_villa_text;

  /// No description provided for @i_premi_text.
  ///
  /// In it, this message translates to:
  /// **'iChiani si aggiudica l\'oscar dell\'efficenza energetica nel 2018\n ​Assegnato ad iChiani Il cubo d’oro, l’Oscar per l’efficienza energetica\n Ogni anno a Bolzano vengono premiate col cubo d’oro CasaClima le migliori CaseClima certificate in tutta Italia. CasaClima Awards è una cerimonia che si svolge ogni anno a Bolzano e nella quale vengono consegnati i cubi d’oro CasaClima, riconoscimento dell’efficienza energetica e della sostenibilità ambientale di alcuni tra gli edifici certificati CasaClima nel corso dell’anno. Vengono premiati quegli edifici che spiccano per basso consumo energetico e conseguente minor impatto ambientale, e per elevato benessere per gli abitanti, oltre che per l’utilizzo di materiali ecocompatibili. A chi viene assegnato il cubo d’oro?\n Gli edifici che hanno ottenuto la Certificazione CasaClima Oro o Casaclima A. Tra tutti gli edifici certificati CasaClima in Italia (CasaClima Oro, CasaClima A, CasaClima B) vengono scelti per l’assegnazione dei Cubi d’Oro CasaClima quegli edifici che spiccano tra gli altri per ottima coibentazione, utilizzo di serramenti altamente innovativi, sistemi impiantistici performanti con il massimo sfruttamento delle energie rinnovabili. Si aggiunge inoltre l’elevata qualità architettonica. Non ci sono categorie: possono essere premiate residenze unifamiliari o plurifamiliari, così come strutture ricettive o edifici scolastici o edifici adibiti ad uffici. Non c’è inoltre differenza tra edifici di nuova costruzione ed risanamento. Il Plus di Villa iChiani\n Vivere un esperienza in un edificio nZEB (nearly Zero Energy Building)\n Classificazione Energetica:\n Classe Energetica D.Lgs 192/2005\n Prestazione energetica globale\n A4 0,00 kWh/m2 anno\n Classe Energetica CasaClima\n Classe di efficienza complessiva dell’edificio\n Gold 0 kg CO2/m2a\n Scala di prestazione ITACA\n Livello di sostenibilità ambientale\n Livello 3.51\n Impianto a Banda Larga\n Conforme alla Legge 164/2014\n Edificio 2.0'**
  String get i_premi_text;

  /// No description provided for @servizi.
  ///
  /// In it, this message translates to:
  /// **'Servizi'**
  String get servizi;

  /// No description provided for @verifica_la_disponibilita.
  ///
  /// In it, this message translates to:
  /// **'Verifica la disponibilità'**
  String get verifica_la_disponibilita;

  /// No description provided for @errorNet.
  ///
  /// In it, this message translates to:
  /// **'Qualcosa è andato storto'**
  String get errorNet;

  /// No description provided for @loadingNet.
  ///
  /// In it, this message translates to:
  /// **'Attendi...Verifica la connessione'**
  String get loadingNet;

  /// No description provided for @servizi_subacquei.
  ///
  /// In it, this message translates to:
  /// **'Serzizi subacquei'**
  String get servizi_subacquei;

  /// No description provided for @escursioni_in_barca.
  ///
  /// In it, this message translates to:
  /// **'Escursioni in barca'**
  String get escursioni_in_barca;

  /// No description provided for @lezioni_di_yoga.
  ///
  /// In it, this message translates to:
  /// **'Lezioni di Yoga'**
  String get lezioni_di_yoga;

  /// No description provided for @blackout.
  ///
  /// In it, this message translates to:
  /// **'Cosa fare in caso di blackout?'**
  String get blackout;

  /// No description provided for @piscina.
  ///
  /// In it, this message translates to:
  /// **'Usare correttamente la piscina'**
  String get piscina;

  /// No description provided for @spazzatura.
  ///
  /// In it, this message translates to:
  /// **'In quali giorni passa la spazzatura?'**
  String get spazzatura;

  /// No description provided for @problema.
  ///
  /// In it, this message translates to:
  /// **'Scopri come risolvere il problema'**
  String get problema;

  /// No description provided for @istruzioni_piscina.
  ///
  /// In it, this message translates to:
  /// **'Leggi il regolamento'**
  String get istruzioni_piscina;

  /// No description provided for @rivista.
  ///
  /// In it, this message translates to:
  /// **'sfoglia la rivista'**
  String get rivista;

  /// No description provided for @benvenuto_a_ichiani.
  ///
  /// In it, this message translates to:
  /// **'Benvenuto a '**
  String get benvenuto_a_ichiani;

  /// No description provided for @accedi.
  ///
  /// In it, this message translates to:
  /// **'Accedi'**
  String get accedi;

  /// No description provided for @non_riesci_a_contattarci.
  ///
  /// In it, this message translates to:
  /// **'Non riesci a contattarci?'**
  String get non_riesci_a_contattarci;

  /// No description provided for @contattaci.
  ///
  /// In it, this message translates to:
  /// **'Contattaci'**
  String get contattaci;

  /// No description provided for @regole_piscina_titolo.
  ///
  /// In it, this message translates to:
  /// **'Regole per il buon uso della piscina'**
  String get regole_piscina_titolo;

  /// No description provided for @regole_piscina_testo.
  ///
  /// In it, this message translates to:
  /// **'-I bambini devono essere sempre sorvegliati.\n-Si prega di non nuotare sotto l\'effetto di alcol\n-È obbligatorio fare la doccia prima di entrare in acqua\n-Indossare solo costumi da bagno corretti, qualsiasi abbigliamento è vietato.\n-È vietato portare in piscina cibi e bevande, o qualsiasi oggetto appuntito, che sia pericoloso\n-È consentito l\'uso di occhiali protettivi per orecchie e naso\n- È vietato tuffarsi in piscina\n-È vietato correre o avvicinarsi alla piscina\n-Si prega di notare che per motivi igienici è vietato sputare o urinare all\'interno la piscina\n'**
  String get regole_piscina_testo;

  /// No description provided for @esegui_2_ver.
  ///
  /// In it, this message translates to:
  /// **'Esegui queste\n2 verifiche...'**
  String get esegui_2_ver;

  /// No description provided for @verifica_1.
  ///
  /// In it, this message translates to:
  /// **'Verifica che nel quadro elettrico situato in corridoio ogni coltello sia alzato.'**
  String get verifica_1;

  /// No description provided for @verifica_2.
  ///
  /// In it, this message translates to:
  /// **'Verifica che nella cabina posta dietro al parcheggio il coltello del quadro sia correttamente alzato.'**
  String get verifica_2;

  /// No description provided for @ancora_problemi.
  ///
  /// In it, this message translates to:
  /// **'Hai ancora problemi?'**
  String get ancora_problemi;

  /// No description provided for @annulla.
  ///
  /// In it, this message translates to:
  /// **'Annulla'**
  String get annulla;

  /// No description provided for @sicuro.
  ///
  /// In it, this message translates to:
  /// **'Sicuro di voler uscire?'**
  String get sicuro;

  /// No description provided for @well.
  ///
  /// In it, this message translates to:
  /// **'Benessere e Salute'**
  String get well;

  /// No description provided for @dicono.
  ///
  /// In it, this message translates to:
  /// **'Dicono di noi'**
  String get dicono;

  /// No description provided for @lascia.
  ///
  /// In it, this message translates to:
  /// **'Lascia una recensione'**
  String get lascia;

  /// No description provided for @nome.
  ///
  /// In it, this message translates to:
  /// **'Nome'**
  String get nome;

  /// No description provided for @valuta.
  ///
  /// In it, this message translates to:
  /// **'Valuta'**
  String get valuta;

  /// No description provided for @paese.
  ///
  /// In it, this message translates to:
  /// **'Paese'**
  String get paese;

  /// No description provided for @titolo.
  ///
  /// In it, this message translates to:
  /// **'Titolo'**
  String get titolo;

  /// No description provided for @mess.
  ///
  /// In it, this message translates to:
  /// **'Cosa ne pensi di iChiani?'**
  String get mess;

  /// No description provided for @errorMess.
  ///
  /// In it, this message translates to:
  /// **'Attenzione! Assicurati di aver compilato tutti i campi'**
  String get errorMess;

  /// No description provided for @pubblicato.
  ///
  /// In it, this message translates to:
  /// **'Grazie dal team iChiani!'**
  String get pubblicato;

  /// No description provided for @pubblica.
  ///
  /// In it, this message translates to:
  /// **'PUBBLICA'**
  String get pubblica;

  /// No description provided for @seleziona.
  ///
  /// In it, this message translates to:
  /// **'Seleziona'**
  String get seleziona;

  /// No description provided for @ospedali.
  ///
  /// In it, this message translates to:
  /// **'Ospedali'**
  String get ospedali;

  /// No description provided for @farmacie.
  ///
  /// In it, this message translates to:
  /// **'Farmacie'**
  String get farmacie;

  /// No description provided for @scegli_lingua.
  ///
  /// In it, this message translates to:
  /// **'Scegli la lingua'**
  String get scegli_lingua;

  /// No description provided for @scegli.
  ///
  /// In it, this message translates to:
  /// **'Scegli'**
  String get scegli;

  /// No description provided for @mio.
  ///
  /// In it, this message translates to:
  /// **'Il mio'**
  String get mio;

  /// No description provided for @carrello.
  ///
  /// In it, this message translates to:
  /// **'Carrello'**
  String get carrello;

  /// No description provided for @totale.
  ///
  /// In it, this message translates to:
  /// **'Totale:'**
  String get totale;

  /// No description provided for @paga.
  ///
  /// In it, this message translates to:
  /// **'Paga Adesso'**
  String get paga;

  /// No description provided for @grazie.
  ///
  /// In it, this message translates to:
  /// **'Grazie per il\ntuo ordine!'**
  String get grazie;

  /// No description provided for @grazie_messaggio.
  ///
  /// In it, this message translates to:
  /// **'Grazie per il tuo ordine!'**
  String get grazie_messaggio;

  /// No description provided for @preparare.
  ///
  /// In it, this message translates to:
  /// **'Il team iChiani sta preparando il tuo ordine'**
  String get preparare;

  /// No description provided for @rimosso_1.
  ///
  /// In it, this message translates to:
  /// **'Rimosso dal Carrello'**
  String get rimosso_1;

  /// No description provided for @rimosso_2.
  ///
  /// In it, this message translates to:
  /// **'Hai rimosso l\'articolo dal carrello'**
  String get rimosso_2;

  /// No description provided for @aggiunto.
  ///
  /// In it, this message translates to:
  /// **'aggiunto al carrello'**
  String get aggiunto;

  /// No description provided for @transaction_failed.
  ///
  /// In it, this message translates to:
  /// **'Pagamento non riuscito'**
  String get transaction_failed;

  /// No description provided for @transaction_failed_err.
  ///
  /// In it, this message translates to:
  /// **'Pagamento non riuscito:'**
  String get transaction_failed_err;

  /// No description provided for @transaction_cancelled.
  ///
  /// In it, this message translates to:
  /// **'Pagamento Annullato'**
  String get transaction_cancelled;

  /// No description provided for @caricamento.
  ///
  /// In it, this message translates to:
  /// **'Caricamento...'**
  String get caricamento;

  /// No description provided for @ho_capito.
  ///
  /// In it, this message translates to:
  /// **'Ho capito'**
  String get ho_capito;

  /// No description provided for @istruzioni_vedi.
  ///
  /// In it, this message translates to:
  /// **'Leggi le istruzioni'**
  String get istruzioni_vedi;

  /// No description provided for @istruzioni_titolo.
  ///
  /// In it, this message translates to:
  /// **'Istruzioni'**
  String get istruzioni_titolo;

  /// No description provided for @separa.
  ///
  /// In it, this message translates to:
  /// **'Separa la spazzatura \nin base alla sua tipologia\n'**
  String get separa;

  /// No description provided for @riponi.
  ///
  /// In it, this message translates to:
  /// **'Riponi la spazzatura nel \nrispettivo bidone colorato,\nRicorda che solo l\''**
  String get riponi;

  /// No description provided for @organico.
  ///
  /// In it, this message translates to:
  /// **'organico'**
  String get organico;

  /// No description provided for @e_il.
  ///
  /// In it, this message translates to:
  /// **' e il\n'**
  String get e_il;

  /// No description provided for @non_riciclabile.
  ///
  /// In it, this message translates to:
  /// **'non riciclabile'**
  String get non_riciclabile;

  /// No description provided for @devono.
  ///
  /// In it, this message translates to:
  /// **'\ndevono essere inseriti prima\nin un sacchetto di plastica\ne successivamente nel \nrispettivo bidone colorato'**
  String get devono;

  /// No description provided for @bidone.
  ///
  /// In it, this message translates to:
  /// **'Il bidone deve essere portato\nall\'esterno della villa,\nsulla strada, la sera precedente\ndel giorno in cui viene raccolto'**
  String get bidone;

  /// No description provided for @bidoni.
  ///
  /// In it, this message translates to:
  /// **'I bidoni, una volta svuotati,\ndevono essere riportati\nall\'interno della villa'**
  String get bidoni;

  /// No description provided for @scrivici.
  ///
  /// In it, this message translates to:
  /// **'Scrivici'**
  String get scrivici;

  /// No description provided for @nessun_articolo.
  ///
  /// In it, this message translates to:
  /// **'Nessun articolo nel carrello.'**
  String get nessun_articolo;

  /// No description provided for @tendenza.
  ///
  /// In it, this message translates to:
  /// **'Categorie'**
  String get tendenza;

  /// No description provided for @luoghi.
  ///
  /// In it, this message translates to:
  /// **'Luoghi'**
  String get luoghi;

  /// No description provided for @abbandona.
  ///
  /// In it, this message translates to:
  /// **'Abbandona'**
  String get abbandona;

  /// No description provided for @e_consentito.
  ///
  /// In it, this message translates to:
  /// **'È consentito'**
  String get e_consentito;

  /// No description provided for @e_vietato.
  ///
  /// In it, this message translates to:
  /// **'È vietato'**
  String get e_vietato;

  /// No description provided for @da_sapere.
  ///
  /// In it, this message translates to:
  /// **'Da Sapere'**
  String get da_sapere;

  /// No description provided for @numero_di_emergenza.
  ///
  /// In it, this message translates to:
  /// **'Numeri di emergenza'**
  String get numero_di_emergenza;

  /// No description provided for @regole_della_casa.
  ///
  /// In it, this message translates to:
  /// **'Regole della casa'**
  String get regole_della_casa;

  /// No description provided for @faq_della_casa.
  ///
  /// In it, this message translates to:
  /// **'Faq della casa'**
  String get faq_della_casa;

  /// No description provided for @ciao.
  ///
  /// In it, this message translates to:
  /// **'Ciao'**
  String get ciao;

  /// No description provided for @esplora.
  ///
  /// In it, this message translates to:
  /// **'Esplora'**
  String get esplora;

  /// No description provided for @altri_servizi.
  ///
  /// In it, this message translates to:
  /// **'Servizi\nextra'**
  String get altri_servizi;

  /// No description provided for @documenti.
  ///
  /// In it, this message translates to:
  /// **'Documenti'**
  String get documenti;

  /// No description provided for @mostra_di_piu.
  ///
  /// In it, this message translates to:
  /// **'Mostra altro'**
  String get mostra_di_piu;

  /// No description provided for @chiudi.
  ///
  /// In it, this message translates to:
  /// **'Chiudi'**
  String get chiudi;

  /// No description provided for @sei_in_pericolo.
  ///
  /// In it, this message translates to:
  /// **'Sei in pericolo?'**
  String get sei_in_pericolo;

  /// No description provided for @chiama.
  ///
  /// In it, this message translates to:
  /// **'Chiama'**
  String get chiama;

  /// No description provided for @regole.
  ///
  /// In it, this message translates to:
  /// **'Regole'**
  String get regole;

  /// No description provided for @divieto.
  ///
  /// In it, this message translates to:
  /// **'Divieti'**
  String get divieto;

  /// No description provided for @discoteche.
  ///
  /// In it, this message translates to:
  /// **'Discoteche'**
  String get discoteche;

  /// No description provided for @codice_struttura.
  ///
  /// In it, this message translates to:
  /// **'Il codice struttura è'**
  String get codice_struttura;

  /// No description provided for @nome_struttura.
  ///
  /// In it, this message translates to:
  /// **'Nome struttura'**
  String get nome_struttura;

  /// No description provided for @tipo_struttura.
  ///
  /// In it, this message translates to:
  /// **'Tipo struttura'**
  String get tipo_struttura;

  /// No description provided for @i_tuoi_documenti.
  ///
  /// In it, this message translates to:
  /// **'I tuoi documenti'**
  String get i_tuoi_documenti;

  /// No description provided for @i_miei_dati.
  ///
  /// In it, this message translates to:
  /// **'I miei dati'**
  String get i_miei_dati;

  /// No description provided for @informazioni_account.
  ///
  /// In it, this message translates to:
  /// **'Informazioni account'**
  String get informazioni_account;

  /// No description provided for @dati_del_viaggiatore.
  ///
  /// In it, this message translates to:
  /// **'Dati viaggiatore'**
  String get dati_del_viaggiatore;

  /// No description provided for @elimina_dati_account.
  ///
  /// In it, this message translates to:
  /// **'Elimina dati account'**
  String get elimina_dati_account;

  /// No description provided for @imposta_lingua.
  ///
  /// In it, this message translates to:
  /// **'Imposta lingua'**
  String get imposta_lingua;

  /// No description provided for @diventa_un_host.
  ///
  /// In it, this message translates to:
  /// **'Diventa un host'**
  String get diventa_un_host;

  /// No description provided for @aggiungi_un_viaggiatore.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi un viaggiatore'**
  String get aggiungi_un_viaggiatore;

  /// No description provided for @dati_personali.
  ///
  /// In it, this message translates to:
  /// **'Dati personali'**
  String get dati_personali;

  /// No description provided for @inserisci_i_dati_desc.
  ///
  /// In it, this message translates to:
  /// **'Inserisci i dati del viaggiatore esattamente come appaiono sul suo passaporto o su qualsiasi documento di viaggio'**
  String get inserisci_i_dati_desc;

  /// No description provided for @cognome.
  ///
  /// In it, this message translates to:
  /// **'Cognome'**
  String get cognome;

  /// No description provided for @sesso.
  ///
  /// In it, this message translates to:
  /// **'Sesso'**
  String get sesso;

  /// No description provided for @data_di_nascita.
  ///
  /// In it, this message translates to:
  /// **'Data di nascita'**
  String get data_di_nascita;

  /// No description provided for @nazionalita.
  ///
  /// In it, this message translates to:
  /// **'Nazionalità'**
  String get nazionalita;

  /// No description provided for @aggiungi_un_documento_di_viaggio.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi un documento di viaggio'**
  String get aggiungi_un_documento_di_viaggio;

  /// No description provided for @assicurati_desc.
  ///
  /// In it, this message translates to:
  /// **'Assicurati che questi dati siano uguali a come appaiono sul documento'**
  String get assicurati_desc;

  /// No description provided for @tipo_di_documento.
  ///
  /// In it, this message translates to:
  /// **'Tipo documento'**
  String get tipo_di_documento;

  /// No description provided for @numero_di_documento.
  ///
  /// In it, this message translates to:
  /// **'Numero documento'**
  String get numero_di_documento;

  /// No description provided for @data_di_emissione.
  ///
  /// In it, this message translates to:
  /// **'Data di emissione'**
  String get data_di_emissione;

  /// No description provided for @data_di_scadenza.
  ///
  /// In it, this message translates to:
  /// **'Data di scadenza'**
  String get data_di_scadenza;

  /// No description provided for @salva.
  ///
  /// In it, this message translates to:
  /// **'Salva'**
  String get salva;

  /// No description provided for @le_mie_strutture.
  ///
  /// In it, this message translates to:
  /// **'Le mie strutture'**
  String get le_mie_strutture;

  /// No description provided for @faq_delle_mie_strutture.
  ///
  /// In it, this message translates to:
  /// **'Faq della mia struttura'**
  String get faq_delle_mie_strutture;

  /// No description provided for @orario_checkIn.
  ///
  /// In it, this message translates to:
  /// **'Orario check-in/out'**
  String get orario_checkIn;

  /// No description provided for @i_miei_altri_servizi.
  ///
  /// In it, this message translates to:
  /// **'I miei servizi extra'**
  String get i_miei_altri_servizi;

  /// No description provided for @imposta_wif_struttura.
  ///
  /// In it, this message translates to:
  /// **'Imposta wi-fi della struttura'**
  String get imposta_wif_struttura;

  /// No description provided for @ordini.
  ///
  /// In it, this message translates to:
  /// **'Ordini'**
  String get ordini;

  /// No description provided for @influenza_in_giorni_diversi.
  ///
  /// In it, this message translates to:
  /// **'Impressioni nei diversi giorni'**
  String get influenza_in_giorni_diversi;

  /// No description provided for @lineare.
  ///
  /// In it, this message translates to:
  /// **'Lineare'**
  String get lineare;

  /// No description provided for @curvo.
  ///
  /// In it, this message translates to:
  /// **'Curvo'**
  String get curvo;

  /// No description provided for @impressioni_dei_luoghi_aggiunti.
  ///
  /// In it, this message translates to:
  /// **'Impressioni dei luoghi aggiunti'**
  String get impressioni_dei_luoghi_aggiunti;

  /// No description provided for @membri.
  ///
  /// In it, this message translates to:
  /// **'Membri'**
  String get membri;

  /// No description provided for @aggiungi_membro.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi un membro'**
  String get aggiungi_membro;

  /// No description provided for @inserisci_id_utente.
  ///
  /// In it, this message translates to:
  /// **'Inserisci ID utente'**
  String get inserisci_id_utente;

  /// No description provided for @cerca.
  ///
  /// In it, this message translates to:
  /// **'Cerca'**
  String get cerca;

  /// No description provided for @inserisci_il_nome_del_wifi.
  ///
  /// In it, this message translates to:
  /// **'Inserisci il nome del wifi'**
  String get inserisci_il_nome_del_wifi;

  /// No description provided for @inserisci_una_password.
  ///
  /// In it, this message translates to:
  /// **'Inserisci una password'**
  String get inserisci_una_password;

  /// No description provided for @i_tuoi_servizi.
  ///
  /// In it, this message translates to:
  /// **'I tuoi servizi'**
  String get i_tuoi_servizi;

  /// No description provided for @i_tuoi_clienti.
  ///
  /// In it, this message translates to:
  /// **'I tuoi clienti'**
  String get i_tuoi_clienti;

  /// No description provided for @manage.
  ///
  /// In it, this message translates to:
  /// **'Gestisci la tua struttura'**
  String get manage;

  /// No description provided for @name_surname.
  ///
  /// In it, this message translates to:
  /// **'Nome e cognome'**
  String get name_surname;

  /// No description provided for @id_user.
  ///
  /// In it, this message translates to:
  /// **'ID utente'**
  String get id_user;

  /// No description provided for @abbonamento.
  ///
  /// In it, this message translates to:
  /// **'Abbonamento'**
  String get abbonamento;

  /// No description provided for @renew.
  ///
  /// In it, this message translates to:
  /// **'L\'abbonamento si rinnoverà automaticamente nel giorno '**
  String get renew;

  /// No description provided for @sicuro_eliminare.
  ///
  /// In it, this message translates to:
  /// **'Sicuro di voler eliminare l\'account?'**
  String get sicuro_eliminare;

  /// No description provided for @no_recuperarlo.
  ///
  /// In it, this message translates to:
  /// **'Se elimini l\'account non potrai più recuperarlo'**
  String get no_recuperarlo;

  /// No description provided for @definitivamente.
  ///
  /// In it, this message translates to:
  /// **'Elimina definitivamente'**
  String get definitivamente;

  /// No description provided for @questi_dati.
  ///
  /// In it, this message translates to:
  /// **'Questi dati verranno condivisi con l\'host, non perderai più tempo d\'ora in poi'**
  String get questi_dati;

  /// No description provided for @inviato.
  ///
  /// In it, this message translates to:
  /// **'Inviato'**
  String get inviato;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'it': return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
