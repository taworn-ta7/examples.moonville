import React from 'react';
import { useTranslation } from 'react-i18next';
import { Navigate } from 'react-router-dom';
import {
} from '@mui/material';
import Rest from '../../components/Rest';
import AppBoxMini from '../../layouts/AppBoxMini';
import Constants from '../../Constants';
import AppContext from '../../AppContext';

export default function SignInGooglePage() {
	const { t } = useTranslation();
	const appContext = React.useContext(AppContext);
	const [signIn, setSignIn] = React.useState(false);
	const [done, setDone] = React.useState(false);

	React.useEffect(() => {
		if (!done) {
			setDone(true);

			const uri = `${Constants.baseUri}/authen/google${window.location.search}`;
			const options = {
				method: 'GET',
				headers: Rest.headers(),
			};

			Rest.fetch(uri, options).then((result) => {
				if (result && result.ok) {
					const user = result.json.user;
					const token = result.json.token;
					appContext.signInWithUserAndToken(user, token).then((result) => {
						if (result) {
							setSignIn(true);
						}
					});
				}
			});
		}
	}, [appContext, done]);

	if (signIn) {
		return <Navigate to={`/`} />
	}

	return (
		<AppBoxMini title={t('signInExternal.title')} showMainIcon={true}>
			<div>
				<a href={`/`}>{t('signInExternal.click')}</a>
			</div>
		</AppBoxMini>
	);
}
