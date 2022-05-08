import React from 'react';
import { useTranslation } from 'react-i18next';
import { useNavigate } from 'react-router-dom';
import i18next from 'i18next';
import {
	FormControl,
	InputAdornment,
	IconButton,
	Button,
	TextField,
} from '@mui/material';
import {
	Mail as MailIcon,
	Password as PasswordIcon,
	Visibility,
	VisibilityOff,
	AppRegistration as SignUpIcon,
} from '@mui/icons-material';
import Rest from '../../components/Rest';
import AppBox from '../../layouts/AppBox';
import Constants from '../../Constants';
import Styles from '../../Styles';
import DialogContext from '../../DialogContext';

export default function SignUpPage() {
	const { t } = useTranslation();
	const navigate = useNavigate();
	const dialogContext = React.useContext(DialogContext);
	const [values, setValues] = React.useState({
		email: "",
		password: "",
		showPassword: false,
		confirmPassword: "",
		showConfirmPassword: false,
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
	const handleClickShowPassword = () => {
		setValues({
			...values,
			showPassword: !values.showPassword,
		});
	};
	const handleClickShowConfirmPassword = () => {
		setValues({
			...values,
			showConfirmPassword: !values.showConfirmPassword,
		});
	};
	const handleMouseDownPassword = (event) => {
		event.preventDefault();
	};

	/**
	 * Handle form submit.
	 */
	const handleSubmit = async (event) => {
		event.preventDefault();

		if (values.password !== values.confirmPassword) {
			dialogContext.warningBox(t('validator.isSamePasswords'));
			return;
		}

		const uri = `${Constants.baseUri}/accounts/signup`;
		const options = {
			method: 'POST',
			headers: Rest.headers(),
			body: JSON.stringify({
				'user': {
					'email': values.email.trim(),
					'password': values.password,
					'confirmPassword': values.confirmPassword,
					'locale': i18next.language,
				},
			}),
		};
		const result = await dialogContext.waitRest(uri, options);
		if (!dialogContext.handleRestError(result)) {
			dialogContext.infoBox(t('signUpPage.confirm'), (param) => navigate(-1));
		}
	};

	return (
		<AppBox title={t('signUpPage.title')}>
			<form onSubmit={handleSubmit}>
				<FormControl fullWidth sx={{ m: 1 }}>
					{/* email */}
					<TextField
						id="email"
						label={t('signUpPage.email')}
						placeholder={t('signUpPage.email')}
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

					{/* password */}
					<TextField
						id="password"
						label={t('signUpPage.password')}
						placeholder={t('signUpPage.password')}
						value={values.password}
						type={values.showPassword ? 'text' : 'password'}
						required
						variant="outlined"
						onChange={handleChange('password')}
						inputProps={{ minLength: 4, maxLength: 20 }}
						InputProps={{
							startAdornment: <InputAdornment position="start"><PasswordIcon /></InputAdornment>,
							endAdornment: (
								<InputAdornment position="end">
									<IconButton
										aria-label="toggle password visibility"
										onClick={handleClickShowPassword}
										onMouseDown={handleMouseDownPassword}
										edge="end">
										{values.showPassword ? <VisibilityOff /> : <Visibility />}
									</IconButton>
								</InputAdornment>
							),
						}}
					/>
					{Styles.betweenVertical}

					{/* confirm password */}
					<TextField
						id="confirmPassword"
						label={t('signUpPage.confirmPassword')}
						placeholder={t('signUpPage.confirmPassword')}
						value={values.confirmPassword}
						type={values.showConfirmPassword ? 'text' : 'password'}
						required
						variant="outlined"
						onChange={handleChange('confirmPassword')}
						inputProps={{ minLength: 4, maxLength: 20 }}
						InputProps={{
							startAdornment: <InputAdornment position="start"><PasswordIcon /></InputAdornment>,
							endAdornment: (
								<InputAdornment position="end">
									<IconButton
										aria-label="toggle password visibility"
										onClick={handleClickShowConfirmPassword}
										onMouseDown={handleMouseDownPassword}
										edge="end">
										{values.showPassword ? <VisibilityOff /> : <Visibility />}
									</IconButton>
								</InputAdornment>
							),
						}}
					/>
					{Styles.betweenVertical}

					{/* ok */}
					<Button
						color="primary" variant="contained"
						startIcon={<SignUpIcon />}
						type="submit"
					>
						{t('signUpPage.ok')}
					</Button>
				</FormControl>
			</form>
		</AppBox>
	);
}
