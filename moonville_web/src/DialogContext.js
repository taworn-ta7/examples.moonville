import React from 'react';
import { useTranslation } from 'react-i18next';
import i18next from 'i18next';
import { InfoBox, WarningBox, ErrorBox, QuestionBox } from './components/MessageBox';
import WaitBox from './components/WaitBox';
import Rest from './components/Rest';

export const DialogCallbackContext = React.createContext(null);

export const DialogContext = React.createContext(null);

export function DialogProvider({ children }) {
	const { t } = useTranslation();
	const context = React.useContext(DialogCallbackContext);
	const [message, setMessage] = React.useState('');
	const [infoOpen, infoSetOpen] = React.useState(false);
	const [warningOpen, warningSetOpen] = React.useState(false);
	const [errorOpen, errorSetOpen] = React.useState(false);
	const [questionOpen, questionSetOpen] = React.useState(false);
	const [button0Negative, setButton0Negative] = React.useState(false);
	const [button1Negative, setButton1Negative] = React.useState(false);
	const [waitOpen, waitSetOpen] = React.useState(false);

	/**
	 * Handle close event for all message boxes.
	 */
	const handleClose = (param) => {
		console.log(`dialog close, parameter=${param}`);
		questionSetOpen(false);
		errorSetOpen(false);
		warningSetOpen(false);
		infoSetOpen(false);
		setMessage('');
		if (context.callback) {
			context.callback(param);
			context.callback = null;
		}
	};

	/**
	 * Open info box.
	 */
	const infoBox = (message, callback) => {
		context.callback = callback;
		setMessage(message);
		infoSetOpen(true);
		console.log(`infoBox: ${message}`);
	};

	/**
	 * Open warning box.
	 */
	const warningBox = (message, callback) => {
		context.callback = callback;
		setMessage(message);
		warningSetOpen(true);
		console.log(`warningBox: ${message}`);
	};

	/**
	 * Open error box.
	 */
	const errorBox = (message, callback) => {
		context.callback = callback;
		setMessage(message);
		errorSetOpen(true);
		console.log(`errorBox: ${message}`);
	};

	/**
	 * Open question box.
	 */
	const questionBox = (message, callback, options) => {
		context.callback = callback;
		setMessage(message);
		setButton0Negative(options.button0Negative ? true : false);
		setButton1Negative(options.button1Negative ? true : false);
		questionSetOpen(true);
		console.log(`questionBox: ${message}`);
	};

	/**
	 * Open/close wait box.
	 */
	const waitBox = (open) => {
		const o = open ? true : false;
		waitSetOpen(o);
		console.log(`waitBox: ${o ? 'open' : 'close'}`);
	};

	/**
	 * Call to REST service and manage open/close wait box.
	 */
	const waitRest = async (uri, options) => {
		waitBox(true);
		const result = await Rest.fetch(uri, options);
		waitBox(false);
		return result
	};

	/**
	 * Handle REST error, if it's an error.
	 */
	const handleRestError = (resultFromRest) => {
		if (!resultFromRest) {
			errorBox(t('serviceRunner.message'));
			return true;
		}
		if (!resultFromRest.ok) {
			let message;
			const error = resultFromRest.json.error;
			if (error) {
				if (i18next.language in error.messageLocales)
					message = error.messageLocales[i18next.language];
				else
					message = error.messageLocales['en'];
			}
			else {
				message = t('serviceRunner.message');
			}
			warningBox(message);
			return true;
		}
		return false;
	};

	const value = {
		infoBox,
		warningBox,
		errorBox,
		questionBox,
		waitBox,
		waitRest,
		handleRestError,
	};

	return (
		<DialogContext.Provider value={value}>
			{children}
			<div>
				<InfoBox
					message={message}
					open={infoOpen}
					handleClose={handleClose}
				/>
				<WarningBox
					message={message}
					open={warningOpen}
					handleClose={handleClose}
				/>
				<ErrorBox
					message={message}
					open={errorOpen}
					handleClose={handleClose}
				/>
				<QuestionBox
					message={message}
					button0Negative={button0Negative}
					button1Negative={button1Negative}
					open={questionOpen}
					handleClose={handleClose}
				/>
				<WaitBox
					open={waitOpen}
				/>
			</div>
		</DialogContext.Provider>
	);
}

export default DialogContext;
