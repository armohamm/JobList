using AutoMapper;
using JobList.BusinessLogic.Interfaces;
using JobList.Common.DTOS;
using JobList.Common.Errors;
using JobList.Common.Pagination;
using JobList.Common.Requests;
using JobList.Common.Sorting;
using JobList.DataAccess.Entities;
using JobList.DataAccess.Interfaces;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Net;
using System.Threading.Tasks;
using System.Linq.Expressions;
using System;
using JobList.Common.Extensions;

namespace JobList.BusinessLogic.Services
{
    public class EmployeesService : IEmployeesService
    {
        private readonly IUnitOfWork _uow;
        private readonly IMapper _mapper;

        public EmployeesService(IUnitOfWork uow, IMapper mapper)
        {
            _uow = uow;
            _mapper = mapper;
        }

        public int TotalRecords
        {
            get { return _uow.EmployeesRepository.TotalRecords; }
        }

        public Task<int> CountAsync(Expression<Func<Employee, bool>> predicate = null)
        {
            return _uow.EmployeesRepository.CountAsync(predicate);
        }

        public async Task<EmployeeDTO> CreateEntityAsync(EmployeeRequest modelRequest)
        {
            if (await _uow.EmployeesRepository.ExistAsync(u => u.Email == modelRequest.Email))
            {
                throw new HttpStatusCodeException(HttpStatusCode.BadRequest, "This email already exists!");
            }

            var entity = _mapper.Map<EmployeeRequest, Employee>(modelRequest);

            entity = await _uow.EmployeesRepository.CreateEntityAsync(entity);
            var result = await _uow.SaveAsync();
            if (!result)
            {
                return null;
            }

            if (entity == null) return null;

            var dto = _mapper.Map<Employee, EmployeeDTO>(entity);

            return dto;
        }

        public async Task<bool> DeleteEntityByIdAsync(int id)
        {
            await _uow.EmployeesRepository.DeleteAsync(id);

            var result = await _uow.SaveAsync();

            return result;
        }

        public async Task<IEnumerable<EmployeeDTO>> GetAllEntitiesAsync()
        {
            var entities = await _uow.EmployeesRepository.GetAllEntitiesAsync(
                 include: r => r.Include(o => o.City)
                                .Include(o => o.FavoriteVacancies)
                                .Include(o => o.Role));

            var dtos = _mapper.Map<List<Employee>, List<EmployeeDTO>>(entities);

            return dtos;
        }

        public async Task<EmployeeDTO> GetEntityByIdAsync(int id)
        {
            var entity = await _uow.EmployeesRepository.GetEntityAsync(id,
                 include: r => r.Include(o => o.City)
                                .Include(o => o.FavoriteVacancies)
                                .Include(o => o.Role));

            if (entity == null) return null;

            var dto = _mapper.Map<Employee, EmployeeDTO>(entity);

            return dto;
        }

        public async Task<IEnumerable<EmployeeDTO>> GetRangeOfEntitiesAsync(PaginationUrlQuery paginationUrlQuery = null)
        {
            var entities = await _uow.EmployeesRepository.GetRangeAsync(
                include: u => u.Include(c => c.City),
                paginationUrlQuery: paginationUrlQuery);

            if (entities == null) return null;

            var dtos = _mapper.Map<List<Employee>, List<EmployeeDTO>>(entities);

            return dtos;
        }

        public async Task<IEnumerable<EmployeeDTO>> GetFilteredEntitiesAsync(string searchString, SortingUrlQuery sortingUrlQuery = null, PaginationUrlQuery paginationUrlQuery = null)
        {
            Expression<Func<Employee, bool>> filter = e => true;

            if (!string.IsNullOrEmpty(searchString))
            {
                filter = filter.And(e => e.Email.ToLower().Contains(searchString.ToLower()));
            }

            var entities = await _uow.EmployeesRepository.GetRangeAsync(
                filter: filter,
                include: e => e.Include(c => c.City).Include(o => o.FavoriteVacancies).Include(o => o.Resumes),
                sorting: GetSortField(sortingUrlQuery.SortField),
                sortOrder: sortingUrlQuery.SortOrder,
                paginationUrlQuery: paginationUrlQuery);


            var dtos = _mapper.Map<List<Employee>, List<EmployeeDTO>>(entities);

            return dtos;
        }


        private Expression<Func<Employee, string>> GetSortField(string field)
        {
            switch (field)
            {
                case "Birthdate":
                    return e => e.BirthData.ToString();
                case "Email":
                    return e => e.Email;

                default: return null;
            }
        }


        public async Task<bool> UpdateEntityByIdAsync(EmployeeUpdateRequest modelRequest, int id)
        {
            var entity = _mapper.Map<EmployeeUpdateRequest, Employee>(modelRequest);
            entity.Id = id;

            var updated = await _uow.EmployeesRepository.UpdateAsync(entity);
            var result = await _uow.SaveAsync();

            return result;
        }
    }
}
