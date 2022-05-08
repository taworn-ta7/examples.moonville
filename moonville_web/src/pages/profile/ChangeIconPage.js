import React from 'react';
import { useTranslation } from 'react-i18next';
import { useNavigate } from 'react-router-dom';
import {
	FormControl,
	Typography,
	Button,
	Stack,
} from '@mui/material';
import {
	RestartAlt as ResetIcon,
	History as RevertIcon,
	Update as OkIcon,
} from '@mui/icons-material';
import Rest from '../../components/Rest';
import AppBox from '../../layouts/AppBox';
import Constants from '../../Constants';
import Styles from '../../Styles';
import DialogContext from '../../DialogContext';
import AppContext from '../../AppContext';

export default function ChangeIconPage() {
	const { t } = useTranslation();
	const navigate = useNavigate();
	const dialogContext = React.useContext(DialogContext);
	const appContext = React.useContext(AppContext);
	const item = appContext.login;
	const [selectedFile, setSelectedFile] = React.useState(null);
	const [image, setImage] = React.useState(appContext.icon);
	const [changed, setChanged] = React.useState(false);
	const [upload, setUpload] = React.useState(false);

	/**
	 * Handle upload click.
	 */
	const handleImageUpload = (event) => {
		const file = event.target.files[0];
		setSelectedFile(event.target.files[0]);
		const image = URL.createObjectURL(file);
		setImage(image);
		setChanged(true);
		setUpload(true);
	};

	/**
	 * Handle reset click.
	 */
	const handleImageReset = (event) => {
		event.preventDefault();
		setSelectedFile(null);
		document.getElementById('form').reset();
		setImage(`/images/default-profile-icon.png`);
		setChanged(true);
		setUpload(false);
	};

	/**
	 * Handle revert click.
	 */
	const handleImageRevert = (event) => {
		event.preventDefault();
		setSelectedFile(null);
		document.getElementById('form').reset();
		setImage(appContext.icon);
		setChanged(false);
	};

	/**
	 * Handle form submit.
	 */
	const handleSubmit = async (event) => {
		event.preventDefault();
		if (changed) {
			if (upload) {
				const formData = new FormData();
				formData.append('image', selectedFile, selectedFile.name);

				const uri = `${Constants.baseUri}/profile/icon`;
				const options = {
					method: 'POST',
					headers: Rest.formDataHeaders(),
					body: formData,
				};

				const result = await dialogContext.waitRest(uri, options);
				if (!dialogContext.handleRestError(result)) {
					appContext.loadProfileIcon();
					navigate(-1);
				}
			}
			else {
				const uri = `${Constants.baseUri}/profile/icon`;
				const options = {
					method: 'DELETE',
					headers: Rest.headers(),
				};

				const result = await dialogContext.waitRest(uri, options);
				if (!dialogContext.handleRestError(result)) {
					appContext.loadProfileIcon();
					navigate(-1);
				}
			}
		}
		else {
			navigate(-1);
		}
	};

	return (
		<AppBox title={t('changeIconPage.title')}>
			<form id="form" name="form" onSubmit={handleSubmit}>
				<FormControl fullWidth sx={{ m: 1 }}>
					<Typography variant="h6"><strong>{t('changeIconPage.icon')}</strong></Typography>
					{Styles.betweenVertical}

					{/* icon */}
					<img
						id="icon"
						width={128} height={128}
						src={image} alt={item.email}
					/>
					{Styles.betweenVertical}

					{/* command buttons */}
					<Stack direction="row">
						<input
							id="file" name="file"
							type="file"
							accept="image/png, image/jpeg"
							onChange={handleImageUpload}
						/>
						{Styles.betweenHorizontalSmall}
						<Button
							color="primary" variant="outlined"
							startIcon={<ResetIcon />}
							onClick={handleImageReset}
						>
							{t('imageChooser.reset')}
						</Button>
						{Styles.betweenHorizontalSmall}
						<Button
							color="primary" variant="outlined"
							startIcon={<RevertIcon />}
							onClick={handleImageRevert}
						>
							{t('imageChooser.revert')}
						</Button>
					</Stack>
					{Styles.betweenVertical}

					{/* ok */}
					<Button
						color="primary" variant="contained"
						startIcon={<OkIcon />}
						type="submit"
					>
						{t('changeIconPage.ok')}
					</Button>
				</FormControl>
			</form>
		</AppBox>
	);
}
