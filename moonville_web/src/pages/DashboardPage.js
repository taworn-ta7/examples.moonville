import React from 'react';
import { useTranslation } from 'react-i18next';
import { Typography } from '@mui/material';
import AppBox from '../layouts/AppBox';
import Styles from '../Styles';
import '../Styles.css';
import AppContext from '../AppContext';

export default function DashboardPage() {
	const { t } = useTranslation();
	const appContext = React.useContext(AppContext);
	const item = appContext.login;

	return (
		<AppBox title={t('dashboardPage.title')} showMenu={true} showMoreMenu={true}>
			<img width={128} height={128} src={appContext.icon} alt={item.email} title={item.name} />
			{Styles.betweenVertical}

			<Typography variant="h6"><strong>{item.email}</strong></Typography>
			{Styles.betweenVertical}

			<table>
				<tbody>
					<tr>
						<td><span>{t('dashboardPage.role')}</span></td>
						<td><span>{item.role}</span></td>
					</tr>
					<tr>
						<td><span>{t('dashboardPage.name')}</span></td>
						<td><span>{item.name}</span></td>
					</tr>
					<tr>
						<td><span>{t('dashboardPage.locale')}</span></td>
						<td><span>{item.locale}</span></td>
					</tr>
					<tr>
						<td><span>{t('dashboardPage.signup')}</span></td>
						<td><span>{item.createdAt}</span></td>
					</tr>
				</tbody>
			</table>
		</AppBox>
	);
}
