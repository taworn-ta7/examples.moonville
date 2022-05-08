import React from 'react';
import { useTranslation } from 'react-i18next';
import {
	ThemeProvider,
} from '@mui/material/styles';
import {
	Typography,
	IconButton,
	Button,
	Box,
} from '@mui/material';
import {
} from '@mui/icons-material';
import Rest from '../components/Rest';
import AppBox from '../layouts/AppBox';
import Constants from '../Constants';
import Styles from '../Styles';
import ThemeContext from '../ThemeContext';
import classes from './SettingsPage.module.css';

export default function SettingsPage() {
	const { t, i18n } = useTranslation();
	const themeContext = React.useContext(ThemeContext);

	/**
	 * Handle change locale click.
	 */
	const handleChangeLocale = (event, locale) => {
		event.preventDefault();
		console.log(`change locale to ${locale}`);
		i18n.changeLanguage(locale);

		const uri = `${Constants.baseUri}/settings`;
		const options = {
			method: 'PUT',
			headers: Rest.headers(),
			body: JSON.stringify({
				'user': {
					'locale': locale,
				},
			}),
		};
		Rest.fetch(uri, options);
	};

	/**
	 * Handle change theme click.
	 */
	const handleChangeTheme = (event, index) => {
		event.preventDefault();
		console.log(`change theme to ${index}`);
		themeContext.changeTheme(index);

		const uri = `${Constants.baseUri}/settings`;
		const options = {
			method: 'PUT',
			headers: Rest.headers(),
			body: JSON.stringify({
				'user': {
					'theme': index,
				},
			}),
		};
		Rest.fetch(uri, options);
	};

	/**
	 * Render color.
	 */
	const renderColor = (index) => {
		return (
			<ThemeProvider theme={themeContext.themes[index]}>
				<Button
					color="primary" variant="contained"
					style={{ marginRight: '12px', marginBottom: '12px' }}
					onClick={(event) => handleChangeTheme(event, index)}
				>
					&nbsp;&nbsp;&nbsp;&nbsp;
				</Button>
			</ThemeProvider>
		);
	}

	return (
		<AppBox title={t('settingsPage.title')} showMenu={true}>
			{/* switch languages */}
			<Typography variant="h6"><strong>{t('settingsPage.locale')}</strong></Typography>
			{Styles.betweenVertical}

			{/* Thai */}
			<IconButton
				className={classes.rightIcon} sx={{ p: 0 }}
				onClick={(event) => handleChangeLocale(event, 'th')}
			>
				<img src="/images/locales/th.png" alt="Thai" title={t('switchLocale.th')} />
			</IconButton>

			{/* English */}
			<IconButton
				className={classes.rightIcon} sx={{ p: 0 }}
				onClick={(event) => handleChangeLocale(event, 'en')}
			>
				<img src="/images/locales/en.png" alt="English" title={t('switchLocale.en')} />
			</IconButton>
			{Styles.betweenVerticalBig}

			{/* choose from themes */}
			<Typography variant="h6"><strong>{t('settingsPage.color')}</strong></Typography>
			{Styles.betweenVertical}
			<Box>
				{renderColor(0)}
				{renderColor(1)}
				{renderColor(2)}
				{renderColor(3)}
			</Box>
			<Box>
				{renderColor(4)}
				{renderColor(5)}
				{renderColor(6)}
				{renderColor(7)}
			</Box>
			<Box>
				{renderColor(8)}
				{renderColor(9)}
				{renderColor(10)}
				{renderColor(11)}
			</Box>
			<Box>
				{renderColor(12)}
				{renderColor(13)}
				{renderColor(14)}
				{renderColor(15)}
			</Box>
		</AppBox>
	);
}
