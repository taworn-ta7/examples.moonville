import React from 'react';
import PropTypes from 'prop-types';
import {
	AppBar,
	Toolbar,
	Typography,
} from '@mui/material';

export default function PageHeaderMini(props) {
	return (
		<header>
			<AppBar position="static">
				<Toolbar>
					<Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>{props.title}</Typography>
				</Toolbar>
			</AppBar>
		</header>
	);
}

PageHeaderMini.propTypes = {
	title: PropTypes.string.isRequired,
};
