using JobList.Common.DTOS;
using JobList.Common.Pagination;
using JobList.Common.Requests;
using JobList.Common.Sorting;
using JobList.DataAccess.Entities;
using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Threading.Tasks;

namespace JobList.BusinessLogic.Interfaces
{
    public interface IEmployeesService
    {
        Task<IEnumerable<EmployeeDTO>> GetAllEntitiesAsync();

        Task<IEnumerable<EmployeeDTO>> GetRangeOfEntitiesAsync(PaginationUrlQuery paginationUrlQuery = null);

        Task<IEnumerable<EmployeeDTO>> GetFilteredEntitiesAsync(string searchString, SortingUrlQuery sortingUrlQuery = null, PaginationUrlQuery paginationUrlQuery = null);

        Task<EmployeeDTO> GetEntityByIdAsync(int id);

        Task<EmployeeDTO> CreateEntityAsync(EmployeeRequest modelRequest);

        Task<bool> UpdateEntityByIdAsync(EmployeeRequest modelRequest, int id);

        Task<bool> DeleteEntityByIdAsync(int id);

        Task<int> CountAsync(Expression<Func<Employee, bool>> predicate = null);

        int TotalRecords { get; }
    }
}
