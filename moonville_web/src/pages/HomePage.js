import React from 'react';
import AppContext from '../AppContext';
import AuthenRequired from '../AuthenRequired';
import BeginPage from './BeginPage';
import DashboardPage from './DashboardPage';

export default function HomePage() {
	const appContext = React.useContext(AppContext);
	if (!appContext.login) {
		return (
			<BeginPage />
		);
	}
	else {
		return (
			<AuthenRequired>
				<DashboardPage />
			</AuthenRequired>
		);
	}
}
