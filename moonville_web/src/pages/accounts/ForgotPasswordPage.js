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
	Mail as MailIcon,
	Email as EmailIcon,
} from '@mui/icons-material';
import Rest from '../../components/Rest';
import AppBox from '../../layouts/AppBox';
import Constants from '../../Constants';
import Styles from '../../Styles';
import DialogContext from '../../DialogContext';

export default function ForgotPasswordPage() {
	const { t } = useTranslation();
	const navigate = useNavigate();
	const dialogContext = React.useContext(DialogContext);
	const [values, setValues] = React.useState({
		email: "",
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
		const uri = `${Constants.baseUri}/accounts/request-reset`;
		const options = {
			method: 'POST',
			headers: Rest.headers(),
			body: JSON.stringify({
				'user': {
					'email': values.email.trim(),
				},
			}),
		};
		const result = await dialogContext.waitRest(uri, options);
		if (!dialogContext.handleRestError(result)) {
			dialogContext.infoBox(t('forgotPasswordPage.check'), (param) => navigate(-1));
		}
	};

	return (
		<AppBox title={t('forgotPasswordPage.title')}>
			<form onSubmit={handleSubmit}>
				<FormControl fullWidth sx={{ m: 1 }}>
					{/* email */}
					<TextField
						id="email"
						label={t('forgotPasswordPage.email')}
						placeholder={t('forgotPasswordPage.email')}
						value={values.email}
						type="email"
						required
						variant="outlined"
						onChange={handleChange('email')}
						InputProps={{
							startAdornment: <InputAdornment position="start"><MailIcon /></InputAdornment>,
						}}
					/>
					{Styles.betweenVertical}

					{/* ok */}
					<Button
						color="primary" variant="contained"
						startIcon={<EmailIcon />}
						type="submit"
					>
						{t('forgotPasswordPage.ok')}
					</Button>
				</FormControl>
			</form>
		</AppBox>
	);
}
