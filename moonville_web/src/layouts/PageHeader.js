import React from 'react';
import PropTypes from 'prop-types';
import { useTranslation } from 'react-i18next';
import { useNavigate } from 'react-router-dom';
import {
	AppBar,
	Toolbar,
	IconButton,
	Typography,
	Drawer,
	Menu,
	MenuItem,
	List,
	ListItemText,
	ListItemIcon,
	Divider,
	Box,
	Avatar,
	InputBase,
} from '@mui/material';
import {
	ArrowBack as BackIcon,
	Menu as MenuIcon,
	DirectionsRailway as MainIcon,
	Search as SearchIcon,
	Home as HomeIcon,
	AccountBox as AccountsIcon,
	Settings as SettingsIcon,
	Face as FaceIcon,
	DriveFileRenameOutline as NameIcon,
	Password as PasswordIcon,
	Logout as ExitIcon,
} from '@mui/icons-material';
import {
	styled,
	alpha,
} from '@mui/material/styles';
import AppContext from '../AppContext';
import styles from './PageHeader.module.css';

// ----------------------------------------------------------------------

// These are code from mui.com.  I just used it, and give some credits.

const Search = styled('div')(({ theme }) => ({
	position: 'relative',
	borderRadius: theme.shape.borderRadius,
	backgroundColor: alpha(theme.palette.common.white, 0.15),
	'&:hover': {
		backgroundColor: alpha(theme.palette.common.white, 0.25),
	},
	marginLeft: 0,
	width: '100%',
	[theme.breakpoints.up('sm')]: {
		marginLeft: theme.spacing(1),
		width: 'auto',
	},
}));

const SearchIconWrapper = styled('div')(({ theme }) => ({
	padding: theme.spacing(0, 2),
	height: '100%',
	position: 'absolute',
	pointerEvents: 'none',
	display: 'flex',
	alignItems: 'center',
	justifyContent: 'center',
}));

const StyledInputBase = styled(InputBase)(({ theme }) => ({
	color: 'inherit',
	'& .MuiInputBase-input': {
		padding: theme.spacing(1, 1, 1, 0),
		// vertical padding + font size from searchIcon
		paddingLeft: `calc(1em + ${theme.spacing(4)})`,
		transition: theme.transitions.create('width'),
		width: '100%',
		[theme.breakpoints.up('sm')]: {
			width: '12ch',
			'&:focus': {
				width: '20ch',
			},
		},
	},
}));

// ----------------------------------------------------------------------

export default function PageHeader(props) {
	const { t, i18n } = useTranslation();
	const navigate = useNavigate();
	const appContext = React.useContext(AppContext);
	const item = appContext.login;
	const [anchorEl, setAnchorEl] = React.useState(null);
	const open = Boolean(anchorEl);
	const [drawerOpen, setDrawerOpen] = React.useState(false);
	const [search, setSearch] = React.useState(props.search);
	const [searchOn, setSearchOn] = React.useState(props.search);

	/**
	 * Handle back button click.
	 */
	const handleBack = (event) => {
		event.preventDefault();
		let execute = true;
		if (props.confirmBack)
			execute = props.confirmBack();
		if (execute)
			navigate(-1);
	};

	/**
	 * Handle menu click.
	 */
	const handleMenu = (event, menu) => {
		event.preventDefault();
		let execute = true;
		if (props.confirmMenu)
			execute = props.confirmMenu(menu);
		if (execute) {
			console.log(`execute menu: ${menu}`);
			switch (menu) {
				case 'home':
					navigate('/');
					break;
				case 'accounts':
					navigate('/accounts');
					break;
				case 'settings':
					navigate('/settings');
					break;
				case 'change-icon':
					navigate('/profile/change-icon');
					break;
				case 'change-name':
					navigate('/profile/change-name');
					break;
				case 'change-password':
					navigate('/profile/change-password');
					break;
				case 'exit':
					appContext.signOut();
					navigate('/');
					break;
				default:
					break;
			}
		}
	};

	/**
	 * Select left-top icon with...
	 */
	const renderWith = () => {
		if (props.showMenu) {
			// drawer menu
			return renderDrawerMenu();
		}
		else if (props.showMainIcon) {
			// main icon
			return (
				<IconButton
					size="large" edge="start" color="inherit" aria-label="main" sx={{ mr: 2 }}
				>
					<MainIcon />
				</IconButton>
			);
		}
		else {
			// back button
			return (
				<IconButton
					size="large" edge="start" color="inherit" aria-label="back" sx={{ mr: 2 }}
					onClick={handleBack}
				>
					<BackIcon />
				</IconButton>
			);
		}
	};

	// ----------------------------------------------------------------------

	// Drawer Menu

	const toggleDrawer = (open) => (event) => {
		if (event.type === 'keydown' && (event.key === 'Tab' || event.key === 'Shift')) {
			return;
		}
		setDrawerOpen(open);
	};

	const renderDrawerMenu = () => {
		if (item) {
			return (
				<div>
					<IconButton
						size="large" edge="start" color="inherit" aria-label="menu" sx={{ mr: 2 }}
						onClick={toggleDrawer(true)}
					>
						<MenuIcon />
					</IconButton>

					{/* drawer */}
					<Drawer
						anchor={'left'}
						open={drawerOpen}
						onClose={toggleDrawer(false)}
					>
						<Box
							sx={{ height: 150, margin: '16px' }}
							role="presentation"
						>
							<div style={{ marginBottom: '0.8em' }}>
								<img
									width={80} height={80}
									src={appContext.icon} alt={item.email} title={item.name}
								/>
							</div>
							<div><strong>{t('drawerUi.title')}</strong></div>
							<div>{item.name}</div>
						</Box>
						<Divider />
						<Box
							sx={{ width: 250 }}
							role="presentation"
							onClick={toggleDrawer(false)}
							onKeyDown={toggleDrawer(false)}
						>
							<List>
								<MenuItem onClick={(event) => handleMenu(event, 'home')}>
									<ListItemIcon><HomeIcon /></ListItemIcon>
									<ListItemText primary={t('drawerUi.home')} />
								</MenuItem>
								<MenuItem onClick={(event) => handleMenu(event, 'accounts')}>
									<ListItemIcon><AccountsIcon /></ListItemIcon>
									<ListItemText primary={t('drawerUi.accounts')} />
								</MenuItem>
								<MenuItem onClick={(event) => handleMenu(event, 'settings')}>
									<ListItemIcon><SettingsIcon /></ListItemIcon>
									<ListItemText primary={t('drawerUi.settings')} />
								</MenuItem>
								<MenuItem onClick={(event) => handleMenu(event, 'exit')}>
									<ListItemIcon><ExitIcon /></ListItemIcon>
									<ListItemText primary={t('drawerUi.exit')} />
								</MenuItem>
							</List>
						</Box>
					</Drawer>
				</div>
			);
		}
	}

	// ----------------------------------------------------------------------

	// Profile Menu

	const handleProfileMenuClick = (event) => {
		setAnchorEl(event.currentTarget);
	};

	const handleProfileMenuClose = () => {
		setAnchorEl(null);
	};

	const renderMoreMenu = () => {
		if (props.showMoreMenu) {
			return (
				<div>
					<MenuItem onClick={(event) => handleMenu(event, 'change-icon')}>
						<ListItemIcon><FaceIcon /></ListItemIcon>
						<ListItemText>{t('appBar.changeIcon')}</ListItemText>
					</MenuItem>
					<MenuItem onClick={(event) => handleMenu(event, 'change-name')}>
						<ListItemIcon><NameIcon /></ListItemIcon>
						<ListItemText>{t('appBar.changeName')}</ListItemText>
					</MenuItem>
					<MenuItem onClick={(event) => handleMenu(event, 'change-password')}>
						<ListItemIcon><PasswordIcon /></ListItemIcon>
						<ListItemText>{t('appBar.changePassword')}</ListItemText>
					</MenuItem>
					<Divider />
				</div>
			);
		}
	};

	const renderProfileMenu = () => {
		if (item) {
			return (
				<div>
					<IconButton
						id="profile-button"
						className={styles.rightIcon} sx={{ p: 0 }}
						onClick={handleProfileMenuClick}
					>
						<Avatar src={appContext.icon} alt={item.email} title={item.name} />
					</IconButton>

					{/* profile menu */}
					<Menu
						id="profile-icon"
						anchorEl={anchorEl}
						open={open}
						onClose={handleProfileMenuClose}
					>
						{renderMoreMenu()}
						<MenuItem onClick={(event) => handleMenu(event, 'exit')}>
							<ListItemIcon><ExitIcon /></ListItemIcon>
							<ListItemText>{t('appBar.exit')}</ListItemText>
						</MenuItem>
					</Menu>
				</div>
			);
		}
	}

	// ----------------------------------------------------------------------

	// Search

	const renderSearch = () => {
		if (props.showSearch) {
			return (
				<Search style={{ marginRight: '12px' }}>
					<SearchIconWrapper><SearchIcon /></SearchIconWrapper>
					<StyledInputBase
						placeholder={t('searchBar.hint')}
						inputProps={{
							value: search,
							onChange: (event) => {
								event.preventDefault();
								setSearch(event.target.value);
							},
							'aria-label': 'search',
						}}
					/>
				</Search>
			);
		}
	};

	// ----------------------------------------------------------------------

	// Locales

	const handleChangeLocale = (event, locale) => {
		event.preventDefault();
		console.log(`change locale to ${locale}`);
		i18n.changeLanguage(locale);
		if (props.handleChangeLocale)
			props.handleChangeLocale(locale);
	};

	const renderLocales = () => {
		if (!appContext.login) {
			return (
				<div>
					{/* Thai */}
					<IconButton
						className={styles.rightIcon} sx={{ p: 0 }}
						onClick={(event) => handleChangeLocale(event, 'th')}
					>
						<img src="/images/locales/th.png" alt="Thai" title={t('switchLocale.th')} />
					</IconButton>

					{/* English */}
					<IconButton
						className={styles.rightIcon} sx={{ p: 0 }}
						onClick={(event) => handleChangeLocale(event, 'en')}
					>
						<img src="/images/locales/en.png" alt="English" title={t('switchLocale.en')} />
					</IconButton>
				</div>
			);
		}
	};

	// ----------------------------------------------------------------------

	// All Right Parts

	const renderRightParts = () => {
		if (props.showRightParts) {
			return (
				<>
					{renderSearch()}
					{renderLocales()}
					{renderProfileMenu()}
				</>
			);
		}
	};

	// ----------------------------------------------------------------------

	React.useEffect(() => {
		const timerId = setTimeout(() => {
			if (search !== searchOn) {
				setSearchOn(search);
				if (props.searchText)
					props.searchText(search);
			}
		}, 2000);
		return () => clearTimeout(timerId);
	}, [search, searchOn, props]);

	return (
		<header>
			<AppBar position="static">
				<Toolbar>
					{/* back button / drawer menu / main icon */}
					{renderWith()}

					{/* title */}
					<Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>{props.title}</Typography>

					{/* right parts */}
					{renderRightParts()}
				</Toolbar>
			</AppBar>
		</header>
	);
}

PageHeader.propTypes = {
	title: PropTypes.string.isRequired,
	showMenu: PropTypes.bool,
	showMoreMenu: PropTypes.bool,
	showMainIcon: PropTypes.bool,
	showRightParts: PropTypes.bool,
	showSearch: PropTypes.bool,
	search: PropTypes.string,
	searchText: PropTypes.func,
	confirmBack: PropTypes.func,
	confirmMenu: PropTypes.func,
	handleChangeLocale: PropTypes.func,
};

PageHeader.defaultProps = {
	showRightParts: true,
	search: '',
};
