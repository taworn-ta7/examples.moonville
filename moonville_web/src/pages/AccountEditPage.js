import React from 'react';
import { useTranslation } from 'react-i18next';
import { useParams, useNavigate } from 'react-router-dom';
import {
	Typography,
	FormControlLabel,
	Checkbox,
	Button,
} from '@mui/material';
import {
	Update as OkIcon,
} from '@mui/icons-material';
import Rest from '../components/Rest';
import AppBox from '../layouts/AppBox';
import Constants from '../Constants';
import Styles from '../Styles';
import '../Styles.css';
import DialogContext from '../DialogContext';

export default function AccountEditPage() {
	const { t } = useTranslation();
	const { id } = useParams('id');
	const navigate = useNavigate();
	const dialogContext = React.useContext(DialogContext);
	const [refresh, setRefresh] = React.useState(true);
	const [item, setItem] = React.useState(null);
	const [disable, setDisable] = React.useState(item && item.disabled ? true : false);

	/**
	 * Handle disable change.
	 */
	const handleDisableChange = (event) => {
		event.preventDefault();
		setDisable(event.target.checked);
	};

	/**
	 * Handle form submit.
	 */
	const handleSubmit = async (event) => {
		event.preventDefault();
		const uri = `${Constants.baseUri}/accounts/users/disable/${id}`;
		const options = {
			method: 'PUT',
			headers: Rest.headers(),
			body: JSON.stringify({
				'user': {
					'disabled': disable ? true : false,
				},
			}),
		};
		const result = await dialogContext.waitRest(uri, options);
		if (!dialogContext.handleRestError(result)) {
			navigate(-1);
		}
	};

	// ----------------------------------------------------------------------

	/**
	 * Load item.
	 */
	const loadItem = async () => {
		const uri = `${Constants.baseUri}/accounts/users/${id}`;
		const options = {
			method: 'GET',
			headers: Rest.headers(),
		};
		const result = await dialogContext.waitRest(uri, options);
		if (!dialogContext.handleRestError(result)) {
			const item = result.json.user;
			setItem(item);
			setDisable(item.disabled)
		}
	};

	/**
	 * Render item.
	 */
	const renderItem = () => {
		if (item) {
			return (
				<form onSubmit={handleSubmit}>
					{/* icon */}
					<img
						width={128} height={128}
						src={`${Constants.baseUri}/accounts/users/icon/${item.email}`}
						alt={item.email} title={item.name}
					/>
					{Styles.betweenVertical}

					{/* email */}
					<Typography variant="h6"><strong>{item.email}</strong></Typography>
					{Styles.betweenVertical}

					{/* information */}
					<table>
						<tbody>
							<tr>
								<td><span>{t('accountEditPage.role')}</span></td>
								<td><span>{item.role}</span></td>
							</tr>
							<tr>
								<td><span>{t('accountEditPage.name')}</span></td>
								<td><span>{item.name}</span></td>
							</tr>
							<tr>
								<td><span>{t('accountEditPage.locale')}</span></td>
								<td><span>{item.locale}</span></td>
							</tr>
							<tr>
								<td><span>{t('accountEditPage.disabled')}</span></td>
								<td><span>{item.disabled}</span></td>
							</tr>
							<tr>
								<td><span>{t('accountEditPage.resigned')}</span></td>
								<td><span>{item.resigned}</span></td>
							</tr>
							<tr>
								<td><span>{t('accountEditPage.signup')}</span></td>
								<td><span>{item.createdAt}</span></td>
							</tr>
						</tbody>
					</table>
					{Styles.betweenVertical}

					{/* disable */}
					<FormControlLabel
						label={t('accountEditPage.disable')}
						control={
							<Checkbox
								checked={disable ? true : false}
								onChange={handleDisableChange}
							/>
						}
					/>
					{Styles.betweenVertical}

					{/* ok */}
					<Button
						color="primary" variant="contained"
						startIcon={<OkIcon />}
						type="submit"
					>
						{t('accountEditPage.ok')}
					</Button>
				</form>
			);
		}
	};

	// ----------------------------------------------------------------------

	React.useEffect(() => {
		if (refresh) {
			setRefresh(false);
			loadItem();
		}
	}, [refresh]);

	return (
		<AppBox title={t('accountEditPage.title', { name: id })}>
			{renderItem()}
		</AppBox>
	);
}
