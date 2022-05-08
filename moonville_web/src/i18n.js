import i18next from 'i18next';
import LanguageDetector from 'i18next-browser-languagedetector';
import { initReactI18next } from 'react-i18next';
import locales from './locales';

(async () => {
	await i18next
		.use(initReactI18next)
		.use(LanguageDetector)
		.init({
			resources: locales,
			fallbackLng: 'en',
			ns: ['translations'],
			defaultNS: 'translations',
			interpolation: {
				escapeValue: false,
			},
			react: {
				useSuspense: false,
			},
		});
})();
