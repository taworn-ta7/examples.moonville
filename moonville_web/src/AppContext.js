import React from 'react';
import { useTranslation } from 'react-i18next';
import Rest from './components/Rest';
import ThemeContext from './ThemeContext';
import DialogContext from './DialogContext';
import Constants from './Constants';

export const AppContext = React.createContext(null);

export function AppProvider({ children }) {
	const { i18n } = useTranslation();
	const themeContext = React.useContext(ThemeContext);
	const dialogContext = React.useContext(DialogContext);
	const [login, setLogin] = React.useState(null);
	const [icon, setIcon] = React.useState(null);
	const [state, setState] = React.useState(null);

	/**
	 * Sign-in.
	 */
	const signIn = async (email, password) => {
		const uri = `${Constants.baseUri}/authen/login`;
		const options = {
			method: 'PUT',
			headers: Rest.headers(),
			body: JSON.stringify({
				'login': {
					'email': email,
					'password': password,
				},
			}),
		};

		const result = await dialogContext.waitRest(uri, options);
		if (!dialogContext.handleRestError(result)) {
			Rest.token = result.json.token;
			localStorage.setItem('token', Rest.token);
			const user = result.json.user;
			i18n.changeLanguage(user.locale);
			themeContext.changeTheme(user.theme);
			await loadProfileIcon();
			setLogin(user);
			return true;
		}
		return false;
	};

	/**
	 * Sign-in with already have user and token.
	 */
	const signInWithUserAndToken = async (user, token) => {
		Rest.token = token;
		localStorage.setItem('token', token);
		i18n.changeLanguage(user.locale);
		themeContext.changeTheme(user.theme);
		await loadProfileIcon();
		setLogin(user);
		return true;
	};

	/**
	 * Sign-out.
	 */
	const signOut = () => {
		const uri = `${Constants.baseUri}/authen/logout`;
		const options = {
			method: 'PUT',
			headers: Rest.headers(),
		};
		Rest.fetch(uri, options);
		Rest.token = '';
		localStorage.removeItem('token');
		localStorage.removeItem('signin');
		setLogin(null);
	};

	/**
	 * Load profile icon.
	 */
	const loadProfileIcon = async () => {
		const uri = `${Constants.baseUri}/profile/icon`;
		const options = {
			method: 'GET',
			headers: Rest.headers(),
		};
		const res = await Rest.fetchRaw(uri, options);
		if (res && res.ok) {
			const blob = await res.blob();
			const icon = URL.createObjectURL(blob);
			setIcon(icon);
			return true;
		}
		return false;
	};

	const value = {
		login,
		icon,
		state,
		signIn,
		signInWithUserAndToken,
		signOut,
		loadProfileIcon,
	};

	React.useEffect(() => {
		async function load() {
			if (state === null) {
				setState('loading');

				// try reload user from token
				const token = localStorage.getItem('token') || '';
				const uri = `${Constants.baseUri}/authen/check`;
				const options = {
					method: 'GET',
					headers: Rest.headers(token),
				};
				const result = await Rest.fetch(uri, options);
				if (result && result.ok) {
					// success
					Rest.token = token;
					const user = result.json.user;
					i18n.changeLanguage(user.locale);
					themeContext.changeTheme(user.theme);
					await loadProfileIcon();
					setLogin(user);
				}
				else {
					// failed, check remember login
					if (localStorage.getItem('remember') && localStorage.getItem('signin')) {
						const uri = `${Constants.baseUri}/authen/login`;
						const options = {
							method: 'PUT',
							headers: Rest.headers(),
							body: JSON.stringify({
								'login': {
									'email': localStorage.getItem('email'),
									'password': localStorage.getItem('password'),
								},
							}),
						};
						const result = await Rest.fetch(uri, options);
						if (result && result.ok) {
							Rest.token = result.json.token;
							localStorage.setItem('token', Rest.token);
							const user = result.json.user;
							i18n.changeLanguage(user.locale);
							themeContext.changeTheme(user.theme);
							await loadProfileIcon();
							setLogin(user);
						}
					}
				}

				setState('loaded');
			}
		}
		load();
	}, [i18n, themeContext, state]);

	return (
		<AppContext.Provider value={value}>
			{children}
		</AppContext.Provider>
	);
}

export default AppContext;
