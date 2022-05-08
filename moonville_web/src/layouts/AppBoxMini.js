import React from 'react';
import PropTypes from 'prop-types';
import PageHeaderMini from './PageHeaderMini';
import PageFooter from './PageFooter';

export default function AppBoxMini(props) {
	const use = '32px';

	return (
		<>
			<PageHeaderMini title={props.title} />
			<main style={{ margin: use }}>
				{props.children}
			</main>
			<PageFooter />
		</>
	);
}

AppBoxMini.propTypes = {
	title: PropTypes.string.isRequired,
};
