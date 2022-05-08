import React from 'react';
import PropTypes from 'prop-types';
import { useTranslation } from 'react-i18next';
import {
	Dialog,
	DialogContent,
	DialogContentText,
	CircularProgress,
} from '@mui/material';

/**
 * Show wait box.
 */
export default function WaitBox(props) {
	const { t } = useTranslation();
	return (
		<Dialog
			open={props.open}
			aria-labelledby="alert-dialog-title"
			aria-describedby="alert-dialog-description"
		>
			<DialogContent style={{ margin: '32px 64px', textAlign: 'center' }}>
				<div style={{ marginBottom: '16px', zoom: '1.5' }}>
					<CircularProgress />
				</div>
				<DialogContentText id="alert-dialog-description">
					{t('waitBox.message')}
				</DialogContentText>
			</DialogContent>
		</Dialog>
	);
}

WaitBox.propTypes = {
	open: PropTypes.bool.isRequired,
};
