import React from 'react';
import { Box } from '@mui/material';

export const Styles = {

	betweenVerticalSmall: (
		<Box sx={{ height: '0.5em' }} />
	),

	betweenVertical: (
		<Box sx={{ height: '1.0em' }} />
	),

	betweenVerticalBig: (
		<Box sx={{ height: '2.0em' }} />
	),

	// ----------------------------------------------------------------------

	betweenHorizontalSmall: (
		<Box sx={{ width: '0.5em' }} />
	),

	betweenHorizontal: (
		<Box sx={{ width: '1.0em' }} />
	),

	betweenHorizontalBig: (
		<Box sx={{ width: '2.0em' }} />
	),

};

export default Styles;
