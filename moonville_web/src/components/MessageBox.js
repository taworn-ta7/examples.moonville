import React from 'react';
import PropTypes from 'prop-types';
import { useTranslation } from 'react-i18next';
import {
	Dialog,
	DialogActions,
	DialogContent,
	DialogContentText,
	DialogTitle,
	Button,
} from '@mui/material';
import {
	Close as CloseIcon,
	CheckCircle as OkIcon,
	DoDisturbOn as CancelIcon,
	Done as YesIcon,
	DoNotDisturb as NoIcon,
	Replay as RetryIcon,
} from '@mui/icons-material';
import styled from '@emotion/styled'

// ----------------------------------------------------------------------

/**
 * Show message box.
 */
export function MessageBox(props) {
	const { t } = useTranslation();

	/**
	 * Handle message box close, and send parameter back to caller. 
	 */
	const handleClose = (event, param) => {
		event.preventDefault();
		props.handleClose(param);
	};

	/**
	 * Render buttons.
	 */
	const renderButtons = () => {
		// expand type to button0 and/or button1
		let icon0 = null;
		let icon1 = null;
		let button0 = null;
		let button1 = null;
		switch (props.type) {
			default:
			case 'close':
				icon0 = <CloseIcon />;
				button0 = t('common.close');
				break;
			case 'ok':
				icon0 = <OkIcon />;
				button0 = t('common.ok');
				break;
			case 'ok-cancel':
				icon0 = <OkIcon />;
				button0 = t('common.ok');
				icon1 = <CancelIcon />;
				button1 = t('common.cancel');
				break;
			case 'yes-no':
				icon0 = <YesIcon />;
				button0 = t('common.yes');
				icon1 = <NoIcon />;
				button1 = t('common.no');
				break;
			case 'retry-cancel':
				icon0 = <RetryIcon />;
				button0 = t('common.retry');
				icon1 = <CancelIcon />;
				button1 = t('common.cancel');
				break;
		}

		// build button(s)
		const styles = {
			fontWeight: 'bold',
			textTransform: 'none',
		};
		if (button1) {
			return (
				<DialogActions>
					<Button
						style={styles}
						color={props.button1Negative ? 'error' : 'primary'}
						startIcon={icon1}
						onClick={(event) => handleClose(event, false)}
					>
						{button1}
					</Button>
					<Button
						style={styles}
						color={props.button0Negative ? 'error' : 'primary'}
						startIcon={icon0}
						onClick={(event) => handleClose(event, true)}
					>
						{button0}
					</Button>
				</DialogActions>
			);
		}
		else {
			return (
				<DialogActions>
					<Button
						style={styles}
						color={props.button0Negative ? 'error' : 'primary'}
						startIcon={icon0}
						onClick={(event) => handleClose(event, false)}
					>
						{button0}
					</Button>
				</DialogActions>
			);
		}
	};

	const Caption = styled.strong`
		color: ${props.captionColor};	
	`;

	return (
		<Dialog
			open={props.open}
			onClose={(event) => handleClose(event, false)}
			aria-labelledby="alert-dialog-title"
			aria-describedby="alert-dialog-description"
		>
			{/* caption */}
			<DialogTitle id="alert-dialog-title">
				<Caption>{props.caption}</Caption>
			</DialogTitle>

			{/* message */}
			<DialogContent>
				<DialogContentText id="alert-dialog-description">
					{props.message}
				</DialogContentText>
			</DialogContent>

			{/* button(s) */}
			{renderButtons()}
		</Dialog>
	);
}

MessageBox.propTypes = {
	type: PropTypes.oneOf(['close', 'ok', 'ok-cancel', 'yes-no', 'retry-cancel']).isRequired,
	message: PropTypes.string.isRequired,
	caption: PropTypes.string,
	captionColor: PropTypes.string,
	button0Negative: PropTypes.bool,
	button1Negative: PropTypes.bool,
	open: PropTypes.bool.isRequired,
	handleClose: PropTypes.func.isRequired,
};

// ----------------------------------------------------------------------

/**
 * Show generic information.
 */
export function InfoBox(props) {
	const { t } = useTranslation();
	return (
		<MessageBox
			type="close"
			message={props.message}
			caption={t('messageBox.info')}
			captionColor="green"
			open={props.open}
			handleClose={props.handleClose}
		/>
	);
}

InfoBox.propTypes = {
	message: PropTypes.string.isRequired,
	open: PropTypes.bool.isRequired,
	handleClose: PropTypes.func.isRequired,
};

// ----------------------------------------------------------------------

/**
 * Show warning.
 */
export function WarningBox(props) {
	const { t } = useTranslation();
	return (
		<MessageBox
			type="close"
			message={props.message}
			caption={t('messageBox.warning')}
			captionColor="darkorange"
			open={props.open}
			handleClose={props.handleClose}
		/>
	);
}

WarningBox.propTypes = {
	message: PropTypes.string.isRequired,
	open: PropTypes.bool.isRequired,
	handleClose: PropTypes.func.isRequired,
};

// ----------------------------------------------------------------------

/**
 * Show error.
 */
export function ErrorBox(props) {
	const { t } = useTranslation();
	return (
		<MessageBox
			type="close"
			message={props.message}
			caption={t('messageBox.error')}
			captionColor="red"
			button0Negative={true}
			open={props.open}
			handleClose={props.handleClose}
		/>
	);
}

ErrorBox.propTypes = {
	message: PropTypes.string.isRequired,
	open: PropTypes.bool.isRequired,
	handleClose: PropTypes.func.isRequired,
};

// ----------------------------------------------------------------------

/**
 * Show question.
 */
export function QuestionBox(props) {
	const { t } = useTranslation();
	return (
		<MessageBox
			type="yes-no"
			message={props.message}
			caption={t('messageBox.question')}
			captionColor="dodgerblue"
			button0Negative={props.button0Negative}
			button1Negative={props.button1Negative}
			open={props.open}
			handleClose={props.handleClose}
		/>
	);
}

QuestionBox.propTypes = {
	message: PropTypes.string.isRequired,
	button0Negative: PropTypes.bool,
	button1Negative: PropTypes.bool,
	open: PropTypes.bool.isRequired,
	handleClose: PropTypes.func.isRequired,
};
