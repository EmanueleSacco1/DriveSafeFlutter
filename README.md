# DriveSafe 🚗💨

Benvenuto in **DriveSafe**, l'applicazione mobile progettata per migliorare la tua sicurezza alla guida e aiutarti a monitorare le performance del tuo veicolo! 🚀

DriveSafe è un'applicazione **cross-platform** sviluppata con **Flutter**, che offre un'esperienza utente fluida e coerente sia su dispositivi Android che iOS.  
Che tu voglia tenere traccia dei tuoi percorsi, monitorare le statistiche di guida o gestire le scadenze della tua auto, DriveSafe è il tuo copilota ideale! 🚦

---

## ✨ Funzionalità Principali

- **Monitoraggio Percorsi in Tempo Reale**  
  Visualizza la tua posizione sulla mappa 🗺️, la velocità corrente e il limite di velocità.  
  Registra i tuoi percorsi con dettagli su distanza, velocità media e massima.

- **Gestione Auto (Garage)**  
  Aggiungi e gestisci le tue auto 🚗.  
  Tieni sotto controllo le scadenze importanti come RCA, revisione e bollo, con indicatori visivi dello stato di scadenza.

- **Analisi Performance di Guida**  
  Ottieni statistiche dettagliate sul tuo stile di guida, inclusi il conteggio di accelerazioni e frenate brusche 📈.

- **Gestione Profilo Utente**  
  Personalizza il tuo profilo con informazioni personali e le licenze di guida in tuo possesso 🧑‍💻.

- **Autenticazione Sicura**  
  Accesso e registrazione utente gestiti tramite **Firebase Authentication** 🔐.

- **Sincronizzazione Cloud**  
  Tutti i dati (percorsi, profili utente) sono sincronizzati in tempo reale con **Firebase Firestore** ☁️.

- **Database Locale Efficiente**  
  Gestione dei dati delle auto tramite un database SQLite locale, ottimizzato con **Drift** 💾.

---

## 🛠️ Tecnologie Utilizzate

- **Flutter**: Framework UI per lo sviluppo cross-platform  
- **Dart**: Linguaggio di programmazione  
- **Firebase**:
  - Authentication: Per la gestione degli utenti  
  - Firestore: Database NoSQL per la memorizzazione dei dati cloud  
- **Drift (SQLite)**: ORM reattivo per la persistenza dei dati locali  
- **Geolocator**: Per l'accesso ai servizi di localizzazione  
- **Flutter Map**: Per la visualizzazione interattiva delle mappe  
- **Provider**: Per la gestione dello stato e l'iniezione delle dipendenze (MVVM)

---

## 🚀 Architettura

DriveSafe è sviluppata seguendo il pattern **Model-View-ViewModel (MVVM)**, che promuove la separazione delle responsabilità e la modularità del codice.  
Il pacchetto **Provider** è utilizzato per gestire lo stato dell'applicazione e l'iniezione delle dipendenze, garantendo un'applicazione reattiva e facile da mantenere.
