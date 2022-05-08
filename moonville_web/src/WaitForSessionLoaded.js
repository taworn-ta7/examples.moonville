import React from 'react';
import { useTranslation } from 'react-i18next';
import AppBoxMini from './layouts/AppBoxMini';
import AppContext from './AppContext';

export default function WaitForSessionLoaded({ children }) {
	const { t } = useTranslation();
	const appContext = React.useContext(AppContext);

	if (!appContext.state || appContext.state === 'loading') {
		return (
			<AppBoxMini title={t('waitForSessionLoaded.title')} />
		);
	}

	return children;
}
