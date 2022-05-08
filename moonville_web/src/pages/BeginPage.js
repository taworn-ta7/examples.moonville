import React from 'react';
import { useTranslation } from 'react-i18next';
import { useNavigate, Link } from 'react-router-dom';
import {
	FormControl,
	FormControlLabel,
	InputAdornment,
	IconButton,
	Button,
	Checkbox,
	TextField,
	Typography,
} from '@mui/material';
import {
	Mail as MailIcon,
	Password as PasswordIcon,
	Visibility,
	VisibilityOff,
	Login as LoginIcon,
	AppRegistration as SignUpIcon,
	Google as GoogleIcon,
	Facebook as FacebookIcon,
	WhatsApp as LineIcon,
} from '@mui/icons-material';
import AppBox from '../layouts/AppBox';
import Styles from '../Styles';
import AppContext from '../AppContext';
import Constants from '../Constants';

export default function BeginPage() {
	const { t } = useTranslation();
	const navigate = useNavigate();
	const appContext = React.useContext(AppContext);
	const [rememberLogin, setRememberLogin] = React.useState(localStorage.getItem('remember') ? true : false);
	const [values, setValues] = React.useState({
		email: localStorage.getItem('email') || "",
		password: localStorage.getItem('password') || "",
		showPassword: false,
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
	const handleMouseDownPassword = (event) => {
		event.preventDefault();
	};

	/**
	 * Handle form submit.
	 */
	const handleSubmit = async (event) => {
		event.preventDefault();
		if (await appContext.signIn(values.email.trim(), values.password)) {
			if (rememberLogin) {
				localStorage.setItem('email', values.email.trim());
				localStorage.setItem('password', values.password);
				localStorage.setItem('remember', 1);
			}
			else {
				localStorage.removeItem('email');
				localStorage.removeItem('password');
				localStorage.removeItem('remember');
			}
			localStorage.setItem('signin', 1);
		}
	};

	return (
		<AppBox title={t('beginPage.title')} showMainIcon={true}>
			<form onSubmit={handleSubmit}>
				<FormControl fullWidth sx={{ m: 1 }}>
					{/* email */}
					<TextField
						id="email"
						placeholder={t('beginPage.email')}
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
						placeholder={t('beginPage.password')}
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
					<div style={{ display: 'flex', justifyContent: 'space-between' }}>
						{/* remember login? */}
						<FormControlLabel
							label={t('beginPage.remember')}
							control={
								<Checkbox
									checked={rememberLogin}
									onChange={(event) => setRememberLogin(event.target.checked)}
								/>
							}
						/>

						{/* forgot password? */}
						<Link to="forgot" style={{ alignSelf: 'center' }}>{t('beginPage.forgotPassword')}</Link>
					</div>
					{Styles.betweenVertical}

					{/* login */}
					<Button
						color="primary" variant="contained"
						startIcon={<LoginIcon />}
						type="submit"
					>
						{t('beginPage.ok')}
					</Button>

					{/* - or - */}
					{Styles.betweenVerticalSmall}
					<Typography align="center">{t('beginPage.or')}</Typography>
					{Styles.betweenVerticalSmall}

					{/* signup */}
					<Button
						color="primary" variant="contained"
						startIcon={<SignUpIcon />}
						onClick={() => navigate('signup')}
					>
						{t('beginPage.signUp')}
					</Button>

					{/* - or - */}
					{Styles.betweenVerticalSmall}
					<Typography align="center">{t('beginPage.or')}</Typography>
					{Styles.betweenVerticalSmall}

					{/* sign-in google */}
					<Button
						style={{ textTransform: 'none' }}
						color="primary" variant="outlined"
						startIcon={<GoogleIcon />}
						onClick={() => { window.location.href = Constants.googleSignIn(); }}
					>
						{t('beginPage.signInGoogle')}
					</Button>
					{Styles.betweenVerticalSmall}

					{/* sign-in facebook */}
					<Button
						style={{ textTransform: 'none' }}
						color="primary" variant="outlined"
						startIcon={<FacebookIcon />}
						onClick={() => { window.location.href = Constants.facebookSignIn(); }}
					>
						{t('beginPage.signInFacebook')}
					</Button>
					{Styles.betweenVerticalSmall}

					{/* sign-in line */}
					<Button
						style={{ textTransform: 'none' }}
						color="primary" variant="outlined"
						startIcon={<LineIcon />}
						onClick={() => { window.location.href = Constants.lineSignIn(); }}
					>
						{t('beginPage.signInLine')}
					</Button>
					{Styles.betweenVerticalSmall}
				</FormControl>
			</form>
		</AppBox >
	);
}
