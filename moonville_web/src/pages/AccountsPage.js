import React from 'react';
import { useTranslation } from 'react-i18next';
import { useSearchParams, useNavigate } from 'react-router-dom';
import {
	Pagination,
	Select,
	MenuItem,
	FormControlLabel,
	Checkbox,
	Avatar,
	Box,
	List,
	ListItemButton,
	ListItemAvatar,
	ListItemText,
} from '@mui/material';
import {
} from '@mui/icons-material';
import Rest from '../components/Rest';
import AppBox from '../layouts/AppBox';
import Constants from '../Constants';
import Styles from '../Styles';
import DialogContext from '../DialogContext';

export default function AccountsPage() {
	const { t } = useTranslation();
	const [searchParams, setSearchParams] = useSearchParams();
	const navigate = useNavigate();
	const dialogContext = React.useContext(DialogContext);
	const [refresh, setRefresh] = React.useState(true);
	const [items, setItems] = React.useState([]);
	const [pageCount, setPageCount] = React.useState(0);
	const [page, setPage] = React.useState(Number(searchParams.get('page')) ?? 0);
	const [order, setOrder] = React.useState(searchParams.get('order') ?? 'id');
	const [search, setSearch] = React.useState(searchParams.get('search') ?? '');
	const [trash, setTrash] = React.useState(Number(searchParams.get('trash')) ? 1 : 0);

	/**
	 * Handle page change.
	 */
	const handlePageChange = (event, page) => {
		event.preventDefault();
		setPage(page - 1);
		setSearchParams({
			page: page - 1,
			order,
			search,
			trash: trash ? 1 : 0,
		});
		setRefresh(true);
	};

	/**
	 * Handle order change.
	 */
	const handleOrderChange = (event) => {
		event.preventDefault();
		const order = event.target.value;
		setOrder(order);
		setSearchParams({
			page,
			order,
			search,
			trash: trash ? 1 : 0,
		});
		setRefresh(true);
	};

	/**
	 * Handle search text.
	 */
	const handleSearchText = (search) => {
		setSearch(search);
		setSearchParams({
			page,
			order,
			search,
			trash: trash ? 1 : 0,
		});
		setRefresh(true);
	};

	/**
	 * Handle trash change.
	 */
	const handleTrashChange = (event) => {
		event.preventDefault();
		const trash = event.target.checked ? 1 : 0;
		setTrash(trash);
		setPage(0);
		setSearchParams({
			page: 0,
			order,
			search,
			trash: trash ? 1 : 0,
		});
		setRefresh(true);
	};

	/**
	 * Handle item click.
	 */
	const handleItemClick = (event, item) => {
		event.preventDefault();
		console.log(`edit: ${item.email}`);
		navigate(`/accounts/${item.email}`);
	};

	// ----------------------------------------------------------------------

	/**
	 * Load items.
	 */
	const loadItems = async () => {
		const uri = `${Constants.baseUri}/accounts/users?page=${page}&order=${order}&search=${search}&trash=${trash}`;
		const options = {
			method: 'GET',
			headers: Rest.headers(),
		};
		const result = await dialogContext.waitRest(uri, options);
		if (!dialogContext.handleRestError(result)) {
			setItems(result.json.users);
			setPageCount(result.json.paginate.pageCount);
		}
	};

	/**
	 * Render items.
	 */
	const renderItems = () => {
		const elements = items.map((item, key) =>
			<ListItemButton key={key} onClick={(event) => handleItemClick(event, item)}>
				<ListItemAvatar>
					<Avatar src={`${Constants.baseUri}/accounts/users/icon/${item.email}`} />
				</ListItemAvatar>
				<ListItemText primary={item.email} secondary={item.name} />
			</ListItemButton>
		);
		return (
			<div>
				{/* query */}
				<div style={{ display: 'flex', justifyContent: 'space-between' }}>
					<Select
						id="ordering"
						value={order}
						defaultValue={''}
						onChange={handleOrderChange}
					>
						<MenuItem value={'id'}>{t('accountsPage.sortBy.id')}</MenuItem>
						<MenuItem value={'email+'}>{t('accountsPage.sortBy.emailAsc')}</MenuItem>
						<MenuItem value={'email-'}>{t('accountsPage.sortBy.emailDesc')}</MenuItem>
						<MenuItem value={'createdAt+'}>{t('accountsPage.sortBy.signUpAsc')}</MenuItem>
						<MenuItem value={'createdAt-'}>{t('accountsPage.sortBy.signUpDesc')}</MenuItem>
					</Select>

					<FormControlLabel
						label={t('accountsPage.trash')}
						control={
							<Checkbox
								checked={trash ? true : false}
								onChange={handleTrashChange}
							/>
						}
					/>
				</div>
				{Styles.betweenVertical}

				{/* items */}
				<Box sx={{ width: 1 }}>
					<List>{elements}</List>
				</Box>
				{Styles.betweenVertical}

				{/* paginator */}
				<Box display="flex" justifyContent="center">
					<Pagination
						showFirstButton showLastButton
						color="primary"
						count={pageCount}
						page={page + 1}
						onChange={handlePageChange}
					/>
				</Box>
			</div>
		);
	};

	// ----------------------------------------------------------------------

	React.useEffect(() => {
		if (refresh) {
			setRefresh(false);
			loadItems();
		}
	}, [refresh, setRefresh]);

	return (
		<AppBox
			title={t('accountsPage.title')}
			showMenu={true}
			showSearch={true}
			search={search}
			searchText={handleSearchText}
		>
			{renderItems()}
		</AppBox>
	);
}
