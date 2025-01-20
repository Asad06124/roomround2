enum YesNo { yes, no, na }

enum UserType {
  superAdmin,
  organizationAdmin,
  manager,
  departmentHead,
  employee,
}

enum APIMethods {
  get,
  post,
  put,
  update,
  delete,
  patch,
}

enum RoomType { allRooms, complete, inProgress }

enum TicketsType { assignedMe, assignedTo, sendTo }

enum SortByType { ASC, DESC }

enum TicketStatus { open, inProgress, closed }

enum LoggerType { debug, info, warning, error }

enum TicketDialogs {
  closeTicket,
  closedTicket,
  openThread,
  openThreadArgue,
  threadTicket,
  seeThread,
  assignedThread
}
