import React from 'react';
import { useTranslation } from 'react-i18next';
import AppBoxMini from './layouts/AppBoxMini';
import AppContext from './AppContext';

export default function AuthenRequired({ children }) {
	const { t } = useTranslation();
	const appContext = React.useContext(AppContext);

	if (!appContext || !appContext.login) {
		return (
			<AppBoxMini title={t('authenRequired.title')} >
				<div>
					<a href={`/`}>{t('authenRequired.back')}</a>
				</div>
			</AppBoxMini>
		);
	}

	return children;
}
