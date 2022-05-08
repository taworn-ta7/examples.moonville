import React from 'react';
import { useTranslation } from 'react-i18next';
import { useNavigate } from 'react-router-dom';
import {
	FormControl,
	InputAdornment,
	IconButton,
	Button,
	TextField,
} from '@mui/material';
import {
	Password as PasswordIcon,
	Visibility,
	VisibilityOff,
	Update as OkIcon,
} from '@mui/icons-material';
import Rest from '../../components/Rest';
import AppBox from '../../layouts/AppBox';
import Constants from '../../Constants';
import Styles from '../../Styles';
import DialogContext from '../../DialogContext';
import AppContext from '../../AppContext';

export default function ChangePasswordPage() {
	const { t } = useTranslation();
	const navigate = useNavigate();
	const dialogContext = React.useContext(DialogContext);
	const appContext = React.useContext(AppContext);
	const [values, setValues] = React.useState({
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

		const uri = `${Constants.baseUri}/profile/password`;
		const options = {
			method: 'PUT',
			headers: Rest.headers(),
			body: JSON.stringify({
				'user': {
					'password': values.password,
					'confirmPassword': values.confirmPassword,
				},
			}),
		};
		const result = await dialogContext.waitRest(uri, options);
		if (!dialogContext.handleRestError(result)) {
			dialogContext.infoBox(t('changePasswordPage.confirm'), (param) => {
				appContext.signOut();
				navigate('/');
			});
		}
	};

	return (
		<AppBox title={t('changePasswordPage.title')}>
			<form onSubmit={handleSubmit}>
				<FormControl fullWidth sx={{ m: 1 }}>
					{/* password */}
					<TextField
						id="password"
						label={t('changePasswordPage.password')}
						placeholder={t('changePasswordPage.password')}
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
						label={t('changePasswordPage.confirmPassword')}
						placeholder={t('changePasswordPage.confirmPassword')}
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
						startIcon={<OkIcon />}
						type="submit"
					>
						{t('changePasswordPage.ok')}
					</Button>
				</FormControl>
			</form>
		</AppBox>
	);
}
