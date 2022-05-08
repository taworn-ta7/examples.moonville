'use strict';

const getPaginate = (page, rowsPerPage, count) => {
	const offset = page * rowsPerPage;
	const pageCount = Math.ceil(count / rowsPerPage);
	const pageSize = page < pageCount - 1
		? rowsPerPage
		: (page >= pageCount ? 0 : count - offset);
	return {
		page,
		offset,
		rowsPerPage,
		count,
		pageIndex: page,
		pageCount,
		pageStart: offset,
		pageStop: offset + pageSize,
		pageSize,
	};
};

const getOrderSchema = (sortDict, order) => {
	const result = [];
	if (typeof order === 'string') {
		const parts = order.split(/[ \t.,:;]+/);
		const regex = /([a-zA-Z0-9_]+)([\+\-]?)/;
		for (let i = 0; i < parts.length; i++) {
			const item = parts[i].trim();
			if (item.length > 0) {
				const matches = regex.exec(item);
				const field = matches[1];
				const reverse = matches[2];
				if (field in sortDict) {
					result.push([
						sortDict[field],
						reverse === '-' ? 'DESC' : 'ASC',
					]);
				}
			}
		}
	}
	return result;
};

const queryGenericData = (req, sortDict) => {
	let page = Number(req.query.page);
	if (!page || page < 0)
		page = 0;
	const order = sortDict ? getOrderSchema(sortDict, req.query.order) : [];
	const search = req.query.search;
	const trash = Number(req.query.trash);
	return {
		page,
		order,
		search,
		trash,
	};
};

module.exports = {
	getPaginate,
	getOrderSchema,
	queryGenericData,
};
