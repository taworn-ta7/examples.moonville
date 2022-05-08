import React from 'react';
import PropTypes from 'prop-types';
import PageHeader from './PageHeader';
import PageFooter from './PageFooter';

export default function AppBox(props) {
	let use = '32px';
	if (props.fit)
		use = 0;

	return (
		<>
			<PageHeader
				title={props.title}
				showMenu={props.showMenu}
				showMoreMenu={props.showMoreMenu}
				showMainIcon={props.showMainIcon}
				showRightParts={props.showRightParts}
				showSearch={props.showSearch}
				search={props.search}
				searchText={props.searchText}
				confirmBack={props.confirmBack}
				confirmMenu={props.confirmMenu}
				handleChangeLocale={props.handleChangeLocale}
			/>

			<main style={{ margin: use }}>
				{props.children}
			</main>

			<PageFooter />
		</>
	);
}

AppBox.propTypes = {
	title: PropTypes.string.isRequired,
	showMenu: PropTypes.bool,
	showMoreMenu: PropTypes.bool,
	showMainIcon: PropTypes.bool,
	showRightParts: PropTypes.bool,
	showSearch: PropTypes.bool,
	search: PropTypes.string,
	fit: PropTypes.bool,
	children: PropTypes.any,
	searchText: PropTypes.func,
	confirmBack: PropTypes.func,
	confirmMenu: PropTypes.func,
	handleChangeLocale: PropTypes.func,
};

AppBox.defaultProps = {
	showRightParts: true,
	search: '',
};
