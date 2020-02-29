-- Version : English - Vjeux, Mugendai

IEF_FILE		= "File:";
IEF_STRING		= "String:";
IEF_LINE		= "Line:";
IEF_COUNT		= "Count:";
IEF_ERROR		= "Error:";

IEF_CANCEL		= "Cancel";
IEF_CLOSE		= "Close";
IEF_REPORT		= "[DIS]Report";

IEF_MESSAGE		= "Please describe the events that caused this bug to appear";
IEF_THX			= "Thanks for reporting!";

if ( GetLocale() == "frFR" ) then
	-- Traduction par Vjeux

	IEF_FILE		= "Fichier :";
	IEF_STRING		= "Cha�ne :";
	IEF_LINE		= "Ligne :";
	IEF_COUNT		= "Nombre :";
	IEF_ERROR		= "Erreur :";

	IEF_CANCEL		= "Annuler";
	IEF_CLOSE		= "Fermer";
	IEF_REPORT		= "Reporter";

	IEF_MESSAGE		= "D�crivez ici quand le bug est arriv�, et si possible comment est-il possible de le reproduire.";
	IEF_THX			= "Merci d'avoir report� un bug !";

elseif ( GetLocale() == "deDE" ) then
	-- Translation by DoctorVanGogh

    IEF_FILE        = "Datei:";
    IEF_STRING      = "Zeichenkette:";
    IEF_LINE        = "Zeile:";
    IEF_COUNT       = "Nummer:";
    IEF_ERROR       = "Fehler:";

    IEF_CANCEL      = "Abbrechen";
    IEF_CLOSE       = "Schlie�en";
    IEF_REPORT      = "Melden";

    IEF_MESSAGE     = "Bitte schreibe eine kurze Erkl�rung wie und wo der Fehler aufgetreten ist (in Englisch plz).";
    IEF_THX         = "Danke f�r die Meldung !";
end