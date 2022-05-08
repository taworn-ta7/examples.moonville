import React from 'react';
import { useTranslation } from 'react-i18next';
import { useNavigate } from 'react-router-dom';
import {
	FormControl,
	InputAdornment,
	Button,
	TextField,
} from '@mui/material';
import {
	Face as FaceIcon,
	Update as OkIcon,
} from '@mui/icons-material';
import Rest from '../../components/Rest';
import AppBox from '../../layouts/AppBox';
import Constants from '../../Constants';
import Styles from '../../Styles';
import DialogContext from '../../DialogContext';
import AppContext from '../../AppContext';

export default function ChangeNamePage() {
	const { t } = useTranslation();
	const navigate = useNavigate();
	const dialogContext = React.useContext(DialogContext);
	const appContext = React.useContext(AppContext);
	const item = appContext.login;
	const [values, setValues] = React.useState({
		name: item ? item.name : "",
	});

	/**
	 * Handle form.
	 */
	const handleChange = (prop) => (event) => {
		setValues({
			...values,
			[prop]: event.target.value,
		});
	};

	/**
	 * Handle form submit.
	 */
	const handleSubmit = async (event) => {
		event.preventDefault();
		const uri = `${Constants.baseUri}/profile/name`;
		const options = {
			method: 'PUT',
			headers: Rest.headers(),
			body: JSON.stringify({
				'user': {
					'name': values.name,
				},
			}),
		};
		const result = await dialogContext.waitRest(uri, options);
		if (!dialogContext.handleRestError(result)) {
			appContext.login.name = values.name;
			navigate(-1);
		}
	};

	return (
		<AppBox title={t('changeNamePage.title')}>
			<form onSubmit={handleSubmit}>
				<FormControl fullWidth sx={{ m: 1 }}>
					{/* name */}
					<TextField
						id="name"
						label={t('changeNamePage.name')}
						placeholder={t('changeNamePage.name')}
						value={values.name}
						type="text"
						required
						variant="outlined"
						onChange={handleChange('name')}
						InputProps={{
							startAdornment: <InputAdornment position="start"><FaceIcon /></InputAdornment>,
						}}
					/>
					{Styles.betweenVertical}

					{/* ok */}
					<Button
						color="primary" variant="contained"
						startIcon={<OkIcon />}
						type="submit"
					>
						{t('changeNamePage.ok')}
					</Button>
				</FormControl>
			</form>
		</AppBox>
	);
}
