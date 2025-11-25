// Prompts
const String phoneNumberPrompt = "Veuillez entrer votre numéro de téléphone (format: 70XXXXXXX) :";
const String otpCodePrompt = "Veuillez entrer le code OTP à 6 chiffres reçu par SMS :";

// Validation errors
const String phoneRequired = "❌ Numéro de téléphone requis. Veuillez réessayer.\n";
const String invalidPhoneFormat = "❌ Format invalide. Le numéro doit commencer par 70, 76, 77 ou 78 suivi de 7 chiffres.\n";
const String otpRequired = "❌ Code OTP requis. Veuillez réessayer.\n";
const String invalidOtpFormat = "❌ Le code OTP doit contenir exactement 6 chiffres.\n";

// Menu
const String menuHeader = "\n========== MENU ==========";
const String menuOption1 = "1️⃣  Get Status";
const String menuOption2 = "2️⃣  S'inscrire";
const String menuOption3 = "3️⃣  Se Connecter";
const String menuOption4 = "4️⃣  Quitter";
const String menuFooter = "==========================";
const String chooseOption = "👉 Choisissez une option : ";

// Status
const String gettingStatus = "🔄 Récupération du statut...";
const String statusRetrieved = "✅ Statut récupéré avec succès:";
const String statusDataPrefix = "📊 ";
const String errorPrefix = "❌ Erreur: ";

// Registration/Login
const String registering = "S'inscrire";
const String loggingIn = "🔐 Connexion";
const String sendingOtp = "📤 Envoi du code OTP...";
const String otpSent = "✅ Code OTP envoyé avec succès !";
const String messagePrefix = "💬 Message: ";

// OTP Verification
const String attemptPrefix = "\n🔢 Tentative ";
const String verifyingOtp = "🔐 Vérification du code OTP...";
const String loginSuccess = "🎉 Connexion réussie !";
const String welcomeTemplate = "👤 Bienvenue {prenom} {nom} !";
const String emailPrefix = "📧 Email: ";
const String phonePrefix = "📱 Téléphone: ";
const String typePrefix = "🏷️  Type: ";
const String statusPrefix = "📊 Statut: ";
const String pressEnter = "\n🔄 Appuyez sur Entrée pour continuer...";

// Errors
const String invalidOtp = "❌ Code OTP invalide. Veuillez saisir un bon code valide.";
const String serverError = "❌ Erreur serveur. Veuillez réessayer.";
const String connectionErrorPrefix = "❌ Erreur de connexion: ";
const String remainingAttemptsTemplate = "💡 Il vous reste {remaining} tentative(s).";
const String maxAttemptsReached = "❌ Nombre maximum de tentatives atteint. Retour au menu principal.";
const String backToMenu = "🔄 Retour au menu principal...";
const String sendOtpErrorPrefix = "❌ Erreur lors de l'envoi du code : ";
const String goodbye = "👋 Au revoir !";
const String invalidOption = "❌ Option invalide. Réessayez.";
